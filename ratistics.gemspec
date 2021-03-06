$LOAD_PATH << File.expand_path("../lib", __FILE__)

require 'ratistics/version'
require 'date'
require 'rbconfig'

Gem::Specification.new do |s|
  s.name        = 'ratistics'
  s.version     = Ratistics::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = "Jerry D'Antonio"
  s.email       = 'jerry.dantonio@gmail.com'
  s.homepage    = 'https://github.com/jdantonio/ratistics/'
  s.summary     = "Ruby statistics functions"
  s.license     = 'MIT'
  s.date        = Date.today.to_s

  s.description = <<-EOF
    Ratistics is a purely functional library that provides basic statistics
    functions to Ruby programs. It is intended for small data sets only.

    This gem was designed for simplicity.
    Ratistics functions operate any any enumerable object and support block
    syntax for accessing complex data. This makes it possible to perform
    statistical computations on a wide range of collections, including
    ActiveRecord record sets.

    Ratistics is pronounced *ra-TIS-tics*. Just like "statistics" but with an 'R'
  EOF

  s.files            = Dir['README*', 'LICENSE*', 'CHANGELOG*']
  s.files           += Dir['{lib,spec}/**/*']
  s.test_files       = Dir['{spec}/**/*']
  s.extra_rdoc_files = ['README.md']
  s.extra_rdoc_files = Dir['README*', 'LICENSE*', 'CHANGELOG*']
  s.require_paths    = ['lib']

  s.required_ruby_version = '>= 1.9.2'
  s.post_install_message  = '"Lies, damned lies, and statistics"'

  s.add_development_dependency 'bundler'
end
