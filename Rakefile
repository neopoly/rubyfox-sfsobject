require 'bundler/gem_tasks'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

# RDoc
require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.title    = "Rubyfox SFSObject"
  rdoc.rdoc_dir = 'rdoc'
  rdoc.main     = 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
end

desc "Run console"
task :console do
  $LOAD_PATH << "./lib"
  require 'rubyfox/sfsobject'

  ENV['SF_DIR'] ||= File.join(File.dirname(__FILE__), 'test', 'vendor', 'smartfox')
  Rubyfox::SFSObject.boot!(ENV['SF_DIR'] + "/lib")

  require 'irb'
  ARGV.clear
  IRB.start
end
