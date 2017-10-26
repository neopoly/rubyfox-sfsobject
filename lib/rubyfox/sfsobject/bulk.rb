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
        Hash          =>  proc { |o, k, v| o.putSFSObject(k, to_sfs(v)) },
        Java::SFSObject => :putSFSObject,
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
          v.each { |e| ary.addSFSObject(to_sfs(e)) }
          o.putSFSArray(k, ary)
        end,
        [Java::SFSObject] => proc do |o, k, v|
          ary = Java::SFSArray.new
          v.each { |e| ary.addSFSObject(e) }
          o.putSFSArray(k, ary)
        end
      }

      TO_HASH = {
        "NULL"              =>  proc { |k, v| nil },
        "UTF_STRING"        =>  :getUtfString,
        "BOOL"              =>  :getBool,
        "INT"               =>  :getInt,
        "DOUBLE"            =>  :getDouble,
        "FLOAT"             =>  :getFloat,
        "UTF_STRING_ARRAY"  =>  :getUtfStringArray,
        "BOOL_ARRAY"        =>  :getBoolArray,
        #"INT_ARRAY"         =>  :getIntArray,
        "INT_ARRAY"         =>  proc { |k, v| v.object.to_a },
        "LONG_ARRAY"        =>  :getLongArray,
        "DOUBLE_ARRAY"      =>  :getDoubleArray,
        "FLOAT_ARRAY"      =>   :getFloatArray,
        "SFS_OBJECT"        =>  proc { |k, v| to_hash(v.object) },
        "SFS_ARRAY"         =>  proc { |k, v| to_array(v.object) }
      }

      # hash -> object
      def to_sfs(hash={})
        object = Java::SFSObject.new
        hash.each do |key, value|
          wrap_value!(object, key, value)
        end
        object
      end

      def wrap_value!(object, key, value)
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
          hash[key.to_sym] = unwrap_value!(object, key)
        end
        hash
      end

      def to_array(object)
        object.iterator.each_with_index.map do |value, index|
          _unwrap(object, index, value)
        end
      end

      def unwrap_value!(object, key)
        value = object.get(key)
        _unwrap(object, key, value)
      end

      def _unwrap(object, key, value)
        raise ArgumentError, "nil value for #{key.inspect}" unless value

        if wrapper_method = _unwrapper(value)
          case wrapper_method
          when Symbol
            object.send(wrapper_method, key)
          else
            wrapper_method.call(key, value)
          end
        else
          raise ArgumentError, "unwrapper for #{key}=#{value.object.inspect} (#{value.type_id}) not found"
        end
      end

      def _unwrapper(value)
        TO_HASH[value.type_id.to_s]
      end
    end
  end
end
