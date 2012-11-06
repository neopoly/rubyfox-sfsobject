# encoding: utf-8 

require 'helper'
require 'rubyfox/sfsobject/schema'

class RubyfoxSFSObjectSchemaTest < RubyfoxCase
  test "empty" do
    assert_schema({}, {})
    assert_schema({}, {:key => "value"}, {})
  end

  context "plain" do
    test "nil is unknown" do
      assert_raises ArgumentError, :message => /wrapper for null.*not found/ do
        assert_schema({ :null => nil }, { :null => "foo" })
      end
    end

    test "string" do
      assert_schema({ :string => String }, { :string => "value" })
      assert_schema({ :string => String }, { :string => "üöäÜÖÄß" })
    end

    test "bool" do
      assert_schema({ :bool => Boolean }, { :bool => true })
      assert_schema({ :bool => Boolean }, { :bool => false })
    end

    test "fixnum" do
      assert_schema({ :fixnum => Fixnum }, { :fixnum => 1 })
      assert_schema({ :fixnum => Fixnum }, { :fixnum => (2 ** 31 - 1) })
      assert_schema({ :fixnum => Fixnum }, { :fixnum => -(2 ** 31) })
    end

    test "fixnum too big for int" do
      assert_raises RangeError, :message => /too big for int/ do
        assert_schema({ :fixnum => Fixnum }, { :fixnum => (2 ** 31) })
      end
    end

    test "float" do
      assert_schema({ :float => Float }, { :float => 1.0 })
      assert_schema({ :float => Float }, { :float => 1.0 / 3 })
    end

    test "nested hash" do
      assert_schema(
        { :sub => { :key => String } },
        { :sub => { :key => "value" } }
      )
    end
  end

  context "array" do
    test "nil is unknown" do
      assert_raises ArgumentError, :message => /wrapper for null.*not found/ do
        assert_schema({ :null => [nil] }, { :null => "foo" })
      end
    end

    test "string" do
      assert_schema({ :string => [String] }, { :string => ["foo", "bar"] })
      assert_schema({ :string => [String] }, { :string => ["foo", "üöäÜÖÄß"] })
      assert_schema({ :string => [String] }, { :string => ["foo", 23] }) # strange?!
    end

    test "bool" do
      assert_schema({ :bool => [Boolean] }, { :bool => [true, false] })
      assert_schema({ :bool => [Boolean] }, { :bool => [true, 23] }) # strange?
    end

    test "fixnum" do
      assert_schema({ :fixnum => [Fixnum] }, { :fixnum => [1, 2] })
      assert_schema({ :fixnum => [Fixnum] }, { :fixnum => [(2 ** 31 - 1), -(2 ** 31)] })
    end

    test "float" do
      assert_schema({ :float => [Float] }, { :float => [1.0, 1.0 / 3] })
    end

    test "nested hash" do
      assert_schema(
        { :sub => [ { :key => String } ] },
        { :sub => [ { :key => "foo" }, { :key => "bar" }] }
      )
    end
  end

  private

  def assert_schema(schema, input, output=input)
    object = Rubyfox::SFSObject::Schema.to_sfs(schema, input)
    hash = Rubyfox::SFSObject::Schema.to_hash(schema, object)
    assert_equal output, hash
  end
end
