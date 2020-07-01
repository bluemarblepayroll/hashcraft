# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'option'
require_relative 'option_set'

module Hashcraft
  # The class API used to define options for a craftable class.  Each class stores its own
  # OptionSet instance along with materializing one for its
  # inheritance chain (child has precedence.)
  module Dsl
    def option?(name)
      option_set.exist?(name)
    end

    def find_option(name)
      option_set.find(name)
    end

    def option(*args)
      opts = args.last.is_a?(Hash) ? args.pop : {}

      args.each do |key|
        option = Option.new(key, opts)

        local_option_set.add(option)
      end

      self
    end

    def option_set
      @option_set ||=
        ancestors
        .reverse
        .select { |a| a < Base }
        .each_with_object(OptionSet.new) { |a, memo| memo.merge!(a.local_option_set) }
    end

    def local_option_set
      @local_option_set ||= OptionSet.new
    end
  end
end
