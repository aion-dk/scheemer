# frozen_string_literal: true

module Scheemer
  module Extensions
    module Bury
      refine ::Hash do
        # https://github.com/dam13n/ruby-bury/blob/master/hash.rb
        def bury(*args)
          raise ::ArgumentError, "2 or more arguments required" if args.count < 2

          if args.count == 2
            self[args[0]] = args[1]
          else
            arg = args.shift
            self[arg] = {} unless self[arg]
            self[arg].bury(*args) unless args.empty?
          end

          self
        end
      end
    end
  end
end
