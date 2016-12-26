#encoding: utf-8
 
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "activerecord_postgresql_procedures/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activerecord_postgresql_procedures"
  s.version     = ActiverecordPostgresqlProcedures::VERSION
  s.authors     = ["Tomáš Kuča"]
  s.email       = ["tomas@kuca.cz"]
  s.homepage    = "https://github.com/tom-kuca/activerecord_postgresql_procedures"
  s.summary     = "Support for PostgreSQL procedures in ActiveRecord"
  s.description = "PostgreSQL allows to create a procedure which returns a result set. The gem modifies ActiveRecord so that it's possible to create (readonly) model based on resultset instead of a database table."
  s.license     = "MIT"

  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "activerecord", "~> 5.0"
  s.add_dependency "pg", "~> 0.17"

  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "guard", "~> 2.6"
  s.add_development_dependency "guard-bundler", "~> 2.0"
  s.add_development_dependency "guard-rspec", "~> 4.3"
end
