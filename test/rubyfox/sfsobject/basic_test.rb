require 'helper'

require 'rubyfox/sfsobject/core_ext'

class RubyfoxSFSObjectBasicTest < RubyfoxCase
  let(:sfs_object) { Rubyfox::SFSObject.new }

  test "to_json works" do
    assert_equal "{}", sfs_object.to_json
  end

  test "from_json works" do
    json = sfs_object.to_json
    object = Rubyfox::SFSObject.from_json(json)
    assert_equal json, object.to_json
  end
end
