module Boolean
end

class TrueClass
  include Boolean
end

class FalseClass
  include Boolean
end

require 'rubyfox/sfsobject/java'

module Rubyfox
  module SFSObject
    class Schema
      TO_SFS = {
        String    => proc { |o, s, k, v| o.put_utf_string(k, v) },
        Boolean   => proc { |o, s, k, v| o.put_bool(k, v) },
        Integer   => proc { |o, s, k, v| o.put_int(k, v) },
        Float     => proc { |o, s, k, v| o.put_double(k, v) },
        Hash      => proc { |o, s, k, v| o.put_sfs_object(k, to_sfs(s, v)) },
        [String]  => proc { |o, s, k, v| o.put_utf_string_array(k, v) },
        [Boolean] => proc { |o, s, k, v| o.put_bool_array(k, v) },
        [Integer] =>  proc do |o, s, k, v|
          collection = Java::ArrayList.new(v.size)
          v.each { |e| collection.add(e.to_java(:int)) }
          o.put_int_array(k, collection)
        end,
        [Float]  => proc { |o, s, k, v| o.put_double_array(k, v) },
        [Hash]    => proc { |o, s, k, v|
          ary = Java::SFSArray.new
          schema = s[0]
          v.each { |e| ary.add_sfs_object(to_sfs(schema, e)) }
          o.put_sfs_array(k, ary)
        }
      }

      TO_HASH = {
        String    => proc { |o, s, k| o.get_utf_string(k) },
        Boolean   => proc { |o, s, k| o.get_bool(k) },
        Integer   => proc { |o, s, k| o.get_int(k) },
        Float     => proc { |o, s, k| o.get_double(k) },
        Hash      => proc { |o, s, k| to_hash(s, o.get_sfs_object(k)) },
        [String]  => proc { |o, s, k| o.get_utf_string_array(k).to_a },
        [Boolean] => proc { |o, s, k| o.get_bool_array(k).to_a },
        [Integer] => proc { |o, s, k| o.get_int_array(k).to_a },
        [Float]   => proc { |o, s, k| o.get_double_array(k).to_a },
        [Hash]    => proc { |o, s, k|
          sfs_ary = o.get_sfs_array(k)
          ary = []
          schema = s[0]
          sfs_ary.size.times do |i|
            ary << to_hash(schema, sfs_ary.get_sfs_object(i))
          end
          ary
        }
      }

      def initialize(schema={})
        @schema = schema
      end

      def to_sfs(hash)
        self.class.to_sfs(@schema, hash)
      end

      def self.to_sfs(schemas, hash)
        object = Java::SFSObject.new
        schemas.each do |key, schema|
          next unless hash && hash.key?(key)
          value = hash[key]
          if method = wrap_method(TO_SFS, schema)
            method.call(object, schema, key, value)
          else
            raise ArgumentError, "wrapper for #{key}=#{value} (#{schema}) not found"
          end
        end
        object
      end

      def to_hash(object)
        self.class.to_hash(@schema, object)
      end

      def self.to_hash(schemas, object)
        hash = {}
        schemas.each do |key, schema|
          next unless object.contains_key(key.to_s)
          if method = wrap_method(TO_HASH, schema)
            hash[key] = method.call(object, schema, key)
          else
            raise ArgumentError, "unwrapper for #{key}=#{value} (#{schema}) not found"
          end
        end
        hash
      end

      def self.wrap_method(map, schema)
        if Hash === schema
          map[Hash]
        elsif Array === schema && Hash === schema.first
          map[[Hash]]
        else
          map[schema]
        end
      end
    end
  end
end
