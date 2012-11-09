# Extends core object with some conversion methods.

require 'rubyfox/sfsobject'
require 'rubyfox/sfsobject/bulk'
require 'rubyfox/sfsobject/schema'
require 'rubyfox/sfsobject/accessor'

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
  include Rubyfox::SFSObject::Accessor

  def to_hash(schema=:none)
    if schema == :none
      Rubyfox::SFSObject::Bulk.to_hash(self)
    else
      Rubyfox::SFSObject::Schema.to_hash(schema, self)
    end
  end

  def self.from_json(data)
    if data == "{}"
      new
    else
      new_from_json_data(data)
    end
  end
end
