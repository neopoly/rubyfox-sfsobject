# encoding: utf-8 

require 'helper'
require 'rubyfox/sfsobject/bulk'

class RubyfoxSFSObjectBulkTest < RubyfoxCase
  let(:bulk) { Rubyfox::SFSObject::Bulk }

  test "empty" do
    assert_conversion Hash.new
  end

  test "converts keys to symbols" do
    assert_conversion({ "key" => nil }, { :key => nil })
  end

  context "plain" do
    test "nil" do
      assert_conversion :null => nil
    end

    test "string" do
      assert_conversion :key => "value"
      assert_conversion :key => "üöäÜÖÄß"
    end

    test "boolean" do
      assert_conversion :true => true, :false => false
    end

    test "fixnum" do
      assert_conversion :fixnum => 1
      assert_conversion :fixnum => (2 ** 31 - 1)
      assert_conversion :fixnum => -(2 ** 31)
    end

    test "fixnum too big for int" do
      assert_raises RangeError, :message => /too big for int/ do
        assert_conversion :fixnum => (2 ** 31)
      end
    end

    test "cannot handle bignum" do
      assert_raises ArgumentError, :message => /Bignum/ do
        assert_conversion :fixnum => (2 ** 63)
      end
    end

    test "float" do
      assert_conversion :float => 1.0
      assert_conversion :float => 1.0 / 3
    end

    test "sub hashes" do
      assert_conversion :sub => { :key => "value" }
      assert_conversion :sub => { :deep => { :key => "value" } }
    end
  end

  context "array" do
    # TODO nil array?

    test "string" do
      assert_conversion :string => ["foo", "bar"]
      assert_conversion :string => ["Föhn", "BÄR"]
    end

    test "boolean" do
      assert_conversion :bool => [ true, true, false ]
    end

    test "fixnum" do
      assert_conversion :fixnum => [ 1, 2, 3 ]
    end

    test "float" do
      assert_conversion :float => [ 1.0, 1.0 / 3 ]
    end

    test "sub hashes" do
      assert_conversion :sub => [{ :key => "value" }]
      assert_conversion :sub => [{ :deep => [{ :key => "value" }] }]
    end
  end

  private

  def assert_conversion(input, output=input)
    object = bulk.to_sfs(input)
    assert_equal output, bulk.to_hash(object)
  end
end
