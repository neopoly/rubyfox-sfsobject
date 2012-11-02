require 'minitest/autorun'
require 'simple_assertions'

require 'rubyfox/sfsobject'

if sf_dir = ENV['SF_DIR']
  Rubyfox::SFSObject.boot!(sf_dir + "/lib")
else
  raise LoadError, "Please points SF_DIR to your SmartFox installation."
end


class RubyfoxCase < MiniTest::Spec
  include SimpleAssertions::AssertRaises

  class << self
    alias :setup :before
    alias :teardown :after
    alias :context :describe
    alias :test :it
  end
end
