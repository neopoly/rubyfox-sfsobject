require 'rubyfox/sfsobject/bulk'

module Rubyfox
  module SFSObject
    module Accessor
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def [](hash)
          new.tap do |sfs_object|
            hash.each do |key, value|
              sfs_object[key] = value
            end
          end
        end
      end

      def [](key)
        Bulk.unwrap_value!(self, key)
      end

      def []=(key, value)
        Bulk.wrap_value!(self, key, value)
      end
    end
  end
end
