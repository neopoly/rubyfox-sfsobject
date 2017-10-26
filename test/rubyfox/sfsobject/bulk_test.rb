# encoding: utf-8 

require 'helper'
require 'rubyfox/sfsobject/bulk'

class RubyfoxSFSObjectBulkTest < RubyfoxCase
  test "empty" do
    assert_conversion Hash.new
  end

  test "converts keys to symbols" do
    assert_conversion({ "key" => nil }, { :key => nil })
  end

  test "raise ArgumentError for nil values" do
    object = Rubyfox::SFSObject.new
    assert_raises ArgumentError, :message => /nil value for :foo/ do
      Rubyfox::SFSObject::Bulk.unwrap_value!(object, :foo)
    end
  end

  context "plain" do
    test "nil" do
      assert_conversion :null => nil
    end

    test "string" do
      assert_conversion :string => "value"
      assert_conversion :string => "üöäÜÖÄß"
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

    test "converts Java's double to Ruby's Float" do
      object = Rubyfox::SFSObject.new
      object.put_double("double", 1.0 / 3)
      hash = Rubyfox::SFSObject::Bulk.to_hash(object)

      assert_in_epsilon 1.0 / 3, hash.fetch(:double)
    end

    test "sub hashes" do
      assert_conversion :sub => { :key => "value" }
      assert_conversion :sub => { :deep => { :key => "value" } }
    end

    test "sfsobject" do
      assert_conversion({ :sfsobject => Rubyfox::SFSObject.new }, { :sfsobject => {} })
    end
  end

  context "array" do
    # TODO nil array?

    test "string" do
      assert_conversion :string => ["foo", "bar"]
      assert_conversion :string => ["Föhn", "BÄR"]
    end

    test "boolean" do
      assert_conversion :bool => [ true, false ]
    end

    test "fixnum" do
      assert_conversion :fixnum => [ 1, 2, 3 ]
    end

    test "float" do
      assert_conversion :float => [ 1.0, 1.0 / 3 ]
    end

    test "converts Java's double array to Ruby's Float array" do
      object = Rubyfox::SFSObject.new
      object.put_double_array("double_array", [1.0 / 3])
      hash = Rubyfox::SFSObject::Bulk.to_hash(object)

      assert_equal [1.0 / 3], hash.fetch(:double_array)
    end

    test "sub hashes" do
      assert_conversion :sub => [{ :key => "value" }]
      assert_conversion :sub => [{ :deep => [{ :key => "value" }] }]
    end

    test "sfsobject" do
      assert_conversion({ :sfsobject => [Rubyfox::SFSObject.new]}, { :sfsobject => [{}] })
    end

    test "loads mixed arrays" do
      object = Rubyfox::SFSObject.from_json('{"mixed": [
        "foo",
        true,
        1.0,
        {
          "deep" => ["Föhn", "BÄR"]
        }
      ]}')
      expected = {
       :mixed => ["foo", true, 1.0, {:deep => ["Föhn", "BÄR"]}]
      }
      assert_equal expected, Rubyfox::SFSObject::Bulk.to_hash(object)
    end
  end

  private

  def assert_conversion(input, output=input)
    object = Rubyfox::SFSObject::Bulk.to_sfs(input)
    assert_equal output, Rubyfox::SFSObject::Bulk.to_hash(object)
  end
end
