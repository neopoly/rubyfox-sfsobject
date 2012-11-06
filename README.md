# Rubyfox::SFSObject [![Build Status](https://secure.travis-ci.org/neopoly/rubyfox-sfsobject.png)](http://travis-ci.org/neopoly/rubyfox-sfsobject)

Converts between SmartFox's SFSObjects and Ruby Hashes.

## Installation

Add this line to your application's Gemfile:

    gem 'rubyfox-sfsobject'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubyfox-sfsobject

## Usage

### Bulk mode

    require 'rubyfox/sfsobject/bulk'
    sfs_object = Rubyfox::SFSObject::Bulk.to_sfs({ :hello => "world" })
    # => SFSObject ready to use in SmartFox
    hash = Rubyfox::SFSObject::Bulk.to_hash(sfs_object)
    # => { :hello => "world" }


### Schema mode

    require 'rubyfox/sfsobject/schema'
    schema = { :hello => String }
    sfs_object = Rubyfox::SFSObject::Schema.to_sfs(schema, { :hello => "world" })
    # => SFSObject ready to use in SmartFox
    hash = Rubyfox::SFSObject::Schema.to_hash(schema, sfs_object)
    # => { :hello => "world" }


### Core extension

You can extend Hash and SFSObject with method shortcuts:

    require 'rubyfox/sfsobject/core_ext'
    sfs_object = { :hello => "world" }.to_sfs
    # => SFSObject
    sfs_object.to_hash
    # { :hello => "world" }

## Caveats

*Note* that all hash keys will be converted to symbols.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
