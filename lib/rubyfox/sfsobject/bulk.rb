require 'rubyfox/sfsobject/java'

module Rubyfox
  module SFSObject
    module Bulk
      extend self

      TO_SFS = {
        NilClass      =>  proc { |o, k, _| o.putNull(k) },
        String        =>  :putUtfString,
        TrueClass     =>  :putBool,
        FalseClass    =>  :putBool,
        Fixnum        =>  :putInt,
        Float         =>  :putDouble,
        Hash          =>  proc { |o, k, v| o.putSFSObject(k, Rubyfox::SFSObject::Bulk.to_sfs(v)) },
        [String]      =>  :putUtfStringArray,
        [TrueClass]   =>  :putBoolArray,
        [FalseClass]  =>  :putBoolArray,
        [Fixnum]      =>  proc do |o, k, v|
          collection = Java::ArrayList.new
          v.each { |e| collection.add(e.to_java(:int)) }
          o.putIntArray(k, collection)
        end,
        [Float]       =>  :putDoubleArray,
        [Hash]        =>  proc do |o, k, v|
          ary = Java::SFSArray.new
          v.each { |e| ary.addSFSObject(Rubyfox::SFSObject::Bulk.to_sfs(e)) }
          o.putSFSArray(k, ary)
        end
      }

      TO_HASH = {
        "NULL"              =>  proc { |h, k, v| h[k.to_sym] = nil },
        "UTF_STRING"        =>  :getUtfString,
        "BOOL"              =>  :getBool,
        "INT"               =>  :getInt,
        "DOUBLE"            =>  :getDouble,
        "UTF_STRING_ARRAY"  =>  :getUtfStringArray,
        "BOOL_ARRAY"        =>  :getBoolArray,
        #"INT_ARRAY"         =>  :getIntArray,
        "INT_ARRAY"         =>  proc { |h, k, v| h[k.to_sym] = v.object.to_a },
        "LONG_ARRAY"        =>  :getLongArray,
        "DOUBLE_ARRAY"      =>  :getDoubleArray,
        "SFS_OBJECT"        =>  proc { |h, k, v| h[k.to_sym] = Rubyfox::SFSObject::Bulk.to_hash(v.object) },
        "SFS_ARRAY"         =>  proc do |h, k, v|
          h[k.to_sym] = v.object.iterator.map { |e| Rubyfox::SFSObject::Bulk.to_hash(e.object) }
        end
      }

      # hash -> object
      def to_sfs(hash={}, schema=nil)
        object = Java::SFSObject.new_instance
        hash.each do |key, value|
          if wrapper_method = _wrapper(value)
            case wrapper_method
            when Symbol
              object.send(wrapper_method, key, value)
            else
              wrapper_method.call(object, key, value)
            end
          else
            raise ArgumentError, "wrapper for #{key}=#{value} (#{value.class}) not found"
          end
        end
        object
      end

      def _wrapper(value)
        case value
        when Array
          TO_SFS[[value.first.class]]
        else
          TO_SFS[value.class]
        end
      end

      # object -> hash
      def to_hash(object)
        hash = {}
        object.keys.each do |key|
          value = object.get(key)
          if wrapper_method = _unwrapper(value)
            case wrapper_method
            when Symbol
              hash[key.to_sym] = object.send(wrapper_method, key)
            else
              wrapper_method.call(hash, key, value)
            end
          else
            raise ArgumentError, "unwrapper for #{key}=#{value.object.inspect} (#{value.type_id}) not found"
          end
        end
        hash
      end

      def _unwrapper(value)
        TO_HASH[value.type_id.to_s]
      end
    end
  end
end
