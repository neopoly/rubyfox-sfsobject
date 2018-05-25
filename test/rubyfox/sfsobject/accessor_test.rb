# encoding: utf-8

require 'helper'

require 'rubyfox/sfsobject/core_ext'

class RubyfoxSFSObjectAccessorTest < RubyfoxCase
  let(:sfs_object) { Rubyfox::SFSObject.new }

  test "mixed keys" do
    sfs_object["string"] = 1
    sfs_object[:symbol] = 2
    assert_equal 1, sfs_object["string"]
    assert_equal 1, sfs_object[:string]
    assert_equal 2, sfs_object[:symbol]
    assert_equal 2, sfs_object["symbol"]
  end

  context "SFSObject[]" do
    test "sets hash" do
      object = Rubyfox::SFSObject[:string => "value", :sub => { :integer => 23 }]
      assert_equal "value", object[:string]
      assert_equal 23, object[:sub][:integer]
    end
  end

  test "key?" do
    assert_equal false, sfs_object.key?(:foo)
    sfs_object[:foo] = "bar"
    assert_equal true, sfs_object.key?(:foo)
  end

  test "delete" do
    sfs_object[:foo] = "bar"
    assert sfs_object.key?(:foo)
    sfs_object.delete(:foo)
    refute sfs_object.key?(:foo)
  end

  context "plain" do
    test "nil" do
      assert_accessor :null => nil
    end

    test "string" do
      assert_accessor :string => "value"
      assert_accessor :string => "üöäÜÖÄß"
    end

    test "boolean" do
      assert_accessor :true => true, :false => false
    end

    test "integer" do
      assert_accessor :integer => 1
      assert_accessor :integer => (2 ** 31 - 1)
      assert_accessor :integer => -(2 ** 31)
    end

    test "integer too big for int" do
      assert_raises RangeError, :message => /too big for int/ do
        assert_accessor :integer => (2 ** 31)
      end
    end

    test "cannot handle bignum" do
      assert_raises ArgumentError, :message => /Bignum/ do
        assert_accessor :integer => (2 ** 63)
      end
    end

    test "float" do
      assert_accessor :float => 1.0
      assert_accessor :float => 1.0 / 3
    end

    test "sub hashes" do
      assert_accessor :sub => { :key => "value" }
      assert_accessor :sub => { :deep => { :key => "value" } }
    end
  end

  context "array" do
    # TODO nil array?

    test "string" do
      assert_accessor :string => ["foo", "bar"]
      assert_accessor :string => ["Föhn", "BÄR"]
    end

    test "boolean" do
      assert_accessor :bool => [ true, false ]
    end

    test "integer" do
      assert_accessor :integer => [ 1, 2, 3 ]
    end

    test "float" do
      assert_accessor :float => [ 1.0, 1.0 / 3 ]
    end

    test "sub hashes" do
      assert_accessor :sub => [{ :key => "value" }]
      assert_accessor :sub => [{ :deep => [{ :key => "value" }] }]
    end
  end

  private

  def assert_accessor(pair)
    key, value = pair.first
    sfs_object[key] = value
    assert_equal value, sfs_object[key]
  end
end
