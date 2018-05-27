ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

if ENV['RUBY_MAPSCRIPT_PATH']
  $: << ENV['RUBY_MAPSCRIPT_PATH']
else
  $: << '/usr/lib/x86_64-linux-gnu/ruby/vendor_ruby/2.3.0/'
end

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup'

if %w[s server c console].any? { |a| ARGV.include?(a) }
  puts "=> Booting Rails"
end
