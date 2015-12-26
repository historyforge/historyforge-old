# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

if ENV['RUBY_MAPSCRIPT_PATH']
  $: << ENV['RUBY_MAPSCRIPT_PATH']
else
  $: << '/usr/lib/x86_64-linux-gnu/ruby/vendor_ruby/2.0.0/'
end

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
