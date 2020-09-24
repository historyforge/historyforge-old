# frozen_string_literal: true

# AR does not require all of AS, but PT does. PT uses core_ext like
# `String#squish`, so we require `active_support/all`. Instead of eagerly
# loading all of AS here, we could put specific `require`s in only the various
# PT files that need them, but this seems easier to troubleshoot, though it may
# add a few milliseconds to rails boot time. If that becomes a pain point, we
# can revisit this decision.
require "active_support/all"

# AR is required for, eg. has_paper_trail.rb, so we could put this `require` in
# all of those files, but it seems easier to troubleshoot if we just make sure
# AR is loaded here before loading *any* of PT. See discussion of
# performance/simplicity tradeoff for activesupport above.
require "active_record"

require "request_store"
require "paper_trail/cleaner"
require "paper_trail/compatibility"
require "paper_trail/config"
require "paper_trail/has_paper_trail"
require "paper_trail/record_history"
require "paper_trail/reifier"
require "paper_trail/request"
require "paper_trail/version_concern"
require "paper_trail/version_number"
require "paper_trail/serializers/json"
require "paper_trail/serializers/yaml"

# An ActiveRecord extension that tracks changes to your models, for auditing or
# versioning.
module PaperTrail
  E_RAILS_NOT_LOADED = <<-EOS.squish.freeze
    PaperTrail has been loaded too early, before rails is loaded. This can
    happen when another gem defines the ::Rails namespace, then PT is loaded,
    all before rails is loaded. You may want to reorder your Gemfile, or defer
    the loading of PT by using `require: false` and a manual require elsewhere.
  EOS
  E_TIMESTAMP_FIELD_CONFIG = <<-EOS.squish.freeze
    PaperTrail.timestamp_field= has been removed, without replacement. It is no
    longer configurable. The timestamp column in the versions table must now be
    named created_at.
  EOS

  extend PaperTrail::Cleaner

  class << self
    # Switches PaperTrail on or off, for all threads.
    # @api public
    def enabled=(value)
      PaperTrail.config.enabled = value
    end

    # Returns `true` if PaperTrail is on, `false` otherwise. This is the
    # on/off switch that affects all threads. Enabled by default.
    # @api public
    def enabled?
      !!PaperTrail.config.enabled
    end

    # Returns PaperTrail's `::Gem::Version`, convenient for comparisons. This is
    # recommended over `::PaperTrail::VERSION::STRING`.
    #
    # Added in 7.0.0
    #
    # @api public
    def gem_version
      ::Gem::Version.new(VERSION::STRING)
    end

    # Set variables for the current request, eg. whodunnit.
    #
    # All request-level variables are now managed here, as of PT 9. Having the
    # word "request" right there in your application code will remind you that
    # these variables only affect the current request, not all threads.
    #
    # Given a block, temporarily sets the given `options`, executes the block,
    # and returns the value of the block.
    #
    # Without a block, this currently just returns `PaperTrail::Request`.
    # However, please do not use `PaperTrail::Request` directly. Currently,
    # `Request` is a `Module`, but in the future it is quite possible we may
    # make it a `Class`. If we make such a choice, we will not provide any
    # warning and will not treat it as a breaking change. You've been warned :)
    #
    # @api public
    def request(options = nil, &block)
      if options.nil? && !block_given?
        Request
      else
        Request.with(options, &block)
      end
    end

    # Set the field which records when a version was created.
    # @api public
    def timestamp_field=(_field_name)
      raise(E_TIMESTAMP_FIELD_CONFIG)
    end

    # Set the PaperTrail serializer. This setting affects all threads.
    # @api public
    def serializer=(value)
      PaperTrail.config.serializer = value
    end

    # Get the PaperTrail serializer used by all threads.
    # @api public
    def serializer
      PaperTrail.config.serializer
    end

    # Returns PaperTrail's global configuration object, a singleton. These
    # settings affect all threads.
    # @api private
    def config
      @config ||= PaperTrail::Config.instance
      yield @config if block_given?
      @config
    end
    alias configure config

    def version
      VERSION::STRING
    end
  end
end

# We use the `on_load` "hook" instead of `ActiveRecord::Base.include` because we
# don't want to cause all of AR to be autloaded yet. See
# https://guides.rubyonrails.org/engines.html#what-are-on-load-hooks-questionmark
# to learn more about `on_load`.
ActiveSupport.on_load(:active_record) do
  include PaperTrail::Model
end

# Require frameworks
if defined?(::Rails)
  # Rails module is sometimes defined by gems like rails-html-sanitizer
  # so we check for presence of Rails.application.
  if defined?(::Rails.application)
    require "paper_trail/frameworks/rails"
  else
    ::Kernel.warn(::PaperTrail::E_RAILS_NOT_LOADED)
  end
else
  require "paper_trail/frameworks/active_record"
end

if defined?(::ActiveRecord)
  ::PaperTrail::Compatibility.check_activerecord(::ActiveRecord.gem_version)
end
