# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

$: << ENV['RUBY_MAPSCRIPT_PATH']

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
