require 'minitest/autorun'

require 'rubyfox/sfsobject'

ENV['SF_DIR'] ||= File.join(File.dirname(__FILE__), 'vendor', 'smartfox')
Rubyfox::SFSObject.boot!(ENV['SF_DIR'] + "/lib")

class RubyfoxCase < Minitest::Spec
  class << self
    alias_method :test, :it
    alias_method :context, :describe
  end

  def assert_raises(exception, options={})
    pattern = options.fetch(:message)
    error = super(exception) { yield }
    assert_match pattern, error.message
  end
end
