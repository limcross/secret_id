# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "secret_id/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "secret_id"
  s.version     = SecretId::VERSION
  s.authors     = ["Sebastián Orellana"]
  s.email       = ["limcross@gmail.com"]
  s.homepage    = "https://github.com/limcross/secret_id"
  s.summary     = "SecretId is a flexible solution for masking the identifiers of ActiveRecord."
  s.description = "SecretId is a flexible solution for masking the identifiers of ActiveRecord."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.2.0"
  s.add_dependency "hashids", "~> 1.0.2"

  s.add_development_dependency "sqlite3"
end
