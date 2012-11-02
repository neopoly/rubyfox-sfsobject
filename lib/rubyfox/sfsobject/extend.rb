# Extends core object with some conversion methods.

require 'rubyfox/sfsobject/bulk'

class Hash
  def to_sfs
    Rubyfox::SFSObject::Bulk.to_sfs(self)
  end
end

class Rubyfox::SFSObject::Java::SFSObject
  def to_hash
    Rubyfox::SFSObject::Bulk.to_hash(self)
  end
end
