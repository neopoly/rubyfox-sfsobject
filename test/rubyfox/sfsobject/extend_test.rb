require 'helper'
require 'rubyfox/sfsobject/extend'

class RubyfoxSFSObjectExtendTest < RubyfoxCase
  test "bulk methods" do
    hash = { :key => "string"}
    assert_equal hash, hash.to_sfs.to_hash
  end
end
