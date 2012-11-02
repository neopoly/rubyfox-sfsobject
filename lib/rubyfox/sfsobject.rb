require 'pathname'

module Rubyfox
  module SFSObject
    def self.boot!(sf_dir)
      unless $LOAD_PATH.include?(sf_dir)
        path = Pathname.new(sf_dir).join("*.jar")
        jars = Dir[path].to_a
        unless jars.empty?
          jars.each { |jar| require jar }
        else
          raise LoadError, "No jars found in #{path}"
        end
      end
    end
  end
end
