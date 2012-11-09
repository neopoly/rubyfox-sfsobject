require 'benchmark/ips'

require 'rubyfox/sfsobject'

ENV['SF_DIR'] ||= File.join(File.dirname(__FILE__), '..', 'vendor', 'smartfox')
Rubyfox::SFSObject.boot!(ENV['SF_DIR'] + "/lib")

require 'rubyfox/sfsobject/core_ext'

empty = {}

short = {
  :formation  => "string",
  :cards      => [1] * 5,
  :trainer    => 1,
  :modes      => ["string", "string"]
}

long = {
  :round           => 1,
  :turn            => "string",
  :picks           => [
    {
      :user          => "string",
      :slot          => 1,
      :card          => 1,
      :slot2         => 1,
      :card2         => 1,
      :with          => "string",
      :modification  => 1
    }
  ] * 2,
  :match_finished  => true,
  :subs            => [
    :user          => "string",
    :out_slot      => 1,
    :in_from_slot  => 1,
    :in_to_slot    => 1
  ] * 2,
  :eval  => {
    :scorer          => "string",
    :used_star_value => true,
    :info  => [{
      :user                => "string",
      :results             => [1, 2, 3],
      :score               => 1,
      :with                => "string",
      :trainer             => 1,
      :modification        => 1,
      :modifications_left  => 1,
      :mods                => [1, 2, 3],
      :sum_values          => [1, 2, 3]
    }] * 2
  }
}

emptyobject = empty.to_sfs
shortobject = short.to_sfs
longobject = long.to_sfs

emptyjson = emptyobject.to_json
shortjson = shortobject.to_json
longjson = longobject.to_json

Benchmark.ips do |x|
  x.report("empty: hash -> sfs") do
    empty.to_sfs
  end

  x.report("empty: json -> sfs") do
    Rubyfox::SFSObject.from_json(emptyjson)
  end

  x.report("empty: sfs -> hash") do
    emptyobject.to_hash
  end

  x.report("empty: sfs -> json") do
    emptyobject.to_json
  end

  x.report("short: hash -> sfs") do
    short.to_sfs
  end

  x.report("short: json -> sfs") do
    Rubyfox::SFSObject.from_json(shortjson)
  end

  x.report("short: sfs -> hash") do
    shortobject.to_hash
  end

  x.report("short: sfs -> json") do
    shortobject.to_json
  end

  x.report("long: hash -> sfs") do
    long.to_sfs
  end

  x.report("long: json -> sfs") do
    Rubyfox::SFSObject.from_json(longjson)
  end

  x.report("long: sfs -> hash") do
    longobject.to_hash
  end

  x.report("long: sfs -> json") do
    longobject.to_json
  end
end
