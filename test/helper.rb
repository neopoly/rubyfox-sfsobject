require 'minitest/autorun'
require 'simple_assertions'

require 'rubyfox/sfsobject'

Rubyfox::SFSObject.boot!

class RubyfoxCase < MiniTest::Spec
  include SimpleAssertions::AssertRaises

  class << self
    alias :setup :before
    alias :teardown :after
    alias :context :describe
    alias :test :it
  end
end
