require 'pathname'

module Rubyfox
  module SFSObject
    def self.boot!(sf_dir)
      unless $LOAD_PATH.include?(sf_dir)
        path = Pathname.new(sf_dir).join("*.jar")
        jars = Dir[path].to_a
        if jars.any?
          jars.each { |jar| require jar }
        else
          raise LoadError, "No jars found in #{path.inspect}"
        end
      end
    end

    def self.new(*args)
      Java::SFSObject.new(*args)
    end

    def self.from_json(data)
      Java::SFSObject.from_json(data)
    end

    def self.[](*args)
      Java::SFSObject[*args]
    end
  end
end
