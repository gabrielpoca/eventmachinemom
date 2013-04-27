# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eventmachinemom/version'

Gem::Specification.new do |spec|
  spec.name          = "eventmachinemom"
  spec.version       = Eventmachinemom::VERSION
  spec.authors       = ["Gabriel Poça"]
  spec.email         = ["gabrielpoca@gmail.com"]
  spec.description   = "EventMachine Websocket MOM"
  spec.summary       = "EventMachine Websocket MOM"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "websocket"
  spec.add_development_dependency "event_emitter"
  spec.add_development_dependency "em-spec"
  spec.add_development_dependency "em-websocket-client"
  spec.add_dependency 'em-websocket'
end
