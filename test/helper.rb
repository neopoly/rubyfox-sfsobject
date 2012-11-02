require 'minitest/autorun'
require 'simple_assertions'

require 'rubyfox/sfsobject'

ENV['SF_DIR'] ||= File.join(File.dirname(__FILE__), 'vendor', 'smartfox')
Rubyfox::SFSObject.boot!(ENV['SF_DIR'] + "/lib")

class RubyfoxCase < MiniTest::Spec
  include SimpleAssertions::AssertRaises

  class << self
    alias :setup :before
    alias :teardown :after
    alias :context :describe
    alias :test :it
  end
end
