require 'helper'
require 'rubyfox/sfsobject/core_xt'

class RubyfoxSFSObjectCoreExtTest < RubyfoxCase
  context "bulk" do
    test "methods" do
      hash = { :key => "value"}
      assert_equal hash, hash.to_sfs.to_hash
    end
  end

  context "schema" do
    test "methods" do
      schema = { :key => String }
      hash = { :key => "value" }
      assert_equal hash, hash.to_sfs(schema).to_hash(schema)
    end

    test "fail w/o valid schema" do
      schema = nil
      hash = { :key => "value" }
      assert_raises NoMethodError, :message => /each/ do
        assert_equal hash, hash.to_sfs(schema).to_hash(schema)
      end
    end
  end
end
