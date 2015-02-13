if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'minitest/autorun'
require 'testem'
require 'simple_assertions'

require 'rubyfox/sfsobject'

ENV['SF_DIR'] ||= File.join(File.dirname(__FILE__), 'vendor', 'smartfox')
Rubyfox::SFSObject.boot!(ENV['SF_DIR'] + "/lib")

class RubyfoxCase < Testem
  include SimpleAssertions::AssertRaises
end
