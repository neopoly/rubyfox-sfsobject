[github]: https://github.com/neopoly/rubyfox-sfsobject
[doc]: http://rubydoc.info/github/neopoly/rubyfox-sfsobject/master/file/README.md
[gem]: https://rubygems.org/gems/rubyfox-sfsobject
[inchpages]: https://inch-ci.org/github/neopoly/rubyfox-sfsobject

# Rubyfox::SFSObject

[![Build Status](https://github.com/neopoly/rubyfox-sfsobject/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/neopoly/rubyfox-sfsobject/actions?query=branch%3Amaster)
[![Gem Version](https://img.shields.io/gem/v/rubyfox-sfsobject.svg)][gem]
[![Inline docs](https://inch-ci.org/github/neopoly/rubyfox-sfsobject.svg?branch=master&style=flat)][inchpages]

[Gem][gem] |
[Source][github] |
[Documentation][doc]

Converts between SmartFox's SFSObjects and Ruby Hashes.

## Installation

Add this line to your application's Gemfile:

    gem 'rubyfox-sfsobject', '~> 0.8.0'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubyfox-sfsobject -v 0.8.0

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

* All hash keys will be converted to symbols
* In "bulk mode"
  * all Ruby's Float values will be converted Java's double (via `putDouble` or `putDoubleArray`)
  * all Java's double values will be converted to Ruby's float (via `getFloat` or `getFloatArray`)

## TODO

*   More docs, please!

## Release

1. Bump `VERSION` in `lib/rubyfox/sfsobject/version.rb`
2. Tweak versions in `README.md`
3. Commit version bump via `git commit -am "Release X.Y.Z"`
4. Run `rake release`

## Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create new Pull Request

