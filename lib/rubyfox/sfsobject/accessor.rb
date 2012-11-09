require 'rubyfox/sfsobject/bulk'

module Rubyfox
  module SFSObject
    module Accessor
      def [](key)
        Bulk.unwrap_value!(self, key)
      end

      def []=(key, value)
        Bulk.wrap_value!(self, key, value)
      end
    end
  end
end
