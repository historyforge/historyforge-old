# frozen_string_literal: true

require "yaml"

module PaperTrail
  module Serializers
    # The default serializer for, e.g. `versions.object`.
    module YAML
      extend self # makes all instance methods become module methods as well

      def load(string)
        ::YAML.load string
      end

      # @param object (Hash | HashWithIndifferentAccess) - Coming from
      # `recordable_object` `object` will be a plain `Hash`. However, due to
      # recent [memory optimizations](https://git.io/fjeYv), when coming from
      # `recordable_object_changes`, it will be a `HashWithIndifferentAccess`.
      def dump(object)
        object = object.to_hash if object.is_a?(HashWithIndifferentAccess)
        ::YAML.dump object
      end

      # Returns a SQL LIKE condition to be used to match the given field and
      # value in the serialized object.
      def where_object_condition(arel_field, field, value)
        arel_field.matches("%\n#{field}: #{value}\n%")
      end

      # Returns a SQL LIKE condition to be used to match the given field and
      # value in the serialized `object_changes`.
      def where_object_changes_condition(*)
        raise <<-STR.squish.freeze
          where_object_changes no longer supports reading YAML from a text
          column. The old implementation was inaccurate, returning more records
          than you wanted. This feature was deprecated in 8.1.0 and removed in
          9.0.0. The json and jsonb datatypes are still supported. See
          discussion at https://github.com/paper-trail-gem/paper_trail/pull/997
        STR
      end
    end
  end
end
