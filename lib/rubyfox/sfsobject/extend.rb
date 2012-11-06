# Extends core object with some conversion methods.

require 'rubyfox/sfsobject/bulk'
require 'rubyfox/sfsobject/schema'

class Hash
  def to_sfs(schema=:none)
    if schema == :none
      Rubyfox::SFSObject::Bulk.to_sfs(self)
    else
      Rubyfox::SFSObject::Schema.to_sfs(schema, self)
    end
  end
end

class Rubyfox::SFSObject::Java::SFSObject
  def to_hash(schema=:none)
    if schema == :none
      Rubyfox::SFSObject::Bulk.to_hash(self)
    else
      Rubyfox::SFSObject::Schema.to_hash(schema, self)
    end
  end
end
