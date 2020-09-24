module Airbrake
  # MonotonicTime is a helper for getting monotonic time suitable for
  # performance measurements. It guarantees that the time is strictly linearly
  # increasing (unlike realtime).
  #
  # @example
  #   MonotonicTime.time_in_ms #=> 287138801.144576
  #
  # @see http://pubs.opengroup.org/onlinepubs/9699919799/functions/clock_getres.html
  # @since v4.2.4
  # @api private
  module MonotonicTime
    class << self
      # @return [Integer] current monotonic time in milliseconds
      def time_in_ms
        time_in_nanoseconds / (10.0**6)
      end

      # @return [Integer] current monotonic time in seconds
      def time_in_s
        time_in_nanoseconds / (10.0**9)
      end

      private

      if defined?(Process::CLOCK_MONOTONIC)

        def time_in_nanoseconds
          Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
        end

      elsif RUBY_ENGINE == 'jruby'

        def time_in_nanoseconds
          java.lang.System.nanoTime
        end

      else

        def time_in_nanoseconds
          time = Time.now
          time.to_i * (10**9) + time.nsec
        end

      end
    end
  end
end
