# Rubyfox::SFSObject

[<img
src="https://secure.travis-ci.org/neopoly/rubyfox-sfsobject.png?branch=master"
alt="Build Status" />](https://travis-ci.org/neopoly/rubyfox-sfsobject) [<img
src="https://badge.fury.io/rb/rubyfox-sfsobject.png" alt="Gem Version"
/>](http://badge.fury.io/rb/rubyfox-sfsobject) [<img
src="https://codeclimate.com/github/neopoly/rubyfox-sfsobject.png"
/>](https://codeclimate.com/github/neopoly/rubyfox-sfsobject)

Converts between SmartFox's SFSObjects and Ruby Hashes.

[Gem](https://rubygems.org/gems/rubyfox-sfsobject) |
[Source](https://github.com/neopoly/rubyfox-sfsobject) |
[Documentation](http://rubydoc.info/github/neopoly/rubyfox-sfsobject/master/fi
le/README.rdoc)

## Installation

Add this line to your application's Gemfile:

    gem 'rubyfox-sfsobject'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubyfox-sfsobject

## Usage

### Bulk mode

```ruby
require 'rubyfox/sfsobject/bulk'
sfs_object = Rubyfox::SFSObject::Bulk.to_sfs({ :hello => "world" })
# => SFSObject ready to use in SmartFox
hash = Rubyfox::SFSObject::Bulk.to_hash(sfs_object)
# => { :hello => "world" }
```

### Schema mode

```ruby
require 'rubyfox/sfsobject/schema'
schema = { :hello => String }
sfs_object = Rubyfox::SFSObject::Schema.to_sfs(schema, { :hello => "world" })
# => SFSObject ready to use in SmartFox
hash = Rubyfox::SFSObject::Schema.to_hash(schema, sfs_object)
# => { :hello => "world" }
```

### Core extension

You can extend Hash and SFSObject with method shortcuts:

```ruby
require 'rubyfox/sfsobject/core_ext'
sfs_object = { :hello => "world" }.to_sfs
# => SFSObject
sfs_object.to_hash
# { :hello => "world" }
```

#### JSON

```ruby
require 'rubyfox/sfsobject/core_ext'
json = sfs_object.to_json
Rubyfox::SFSObject.from_json(json)
```

#### Hash-like access

```ruby
require 'rubyfox/sfsobject/core_ext'
sfs_object = Rubyfox::SFSObject[:meaning_of_life => 42]
sfs_object[:meaning_of_life] # => 42
sfs_object[:string] = "value"
sfs_object[:string] # => "value"
```

## Caveats

**Note** that all hash keys will be converted to symbols.

## TODO

*   More docs, please!


## Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create new Pull Request

