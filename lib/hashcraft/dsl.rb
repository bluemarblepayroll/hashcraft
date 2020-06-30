# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'option'

module Hashcraft
  # The under-lining API used to define options for a craftable class.
  module Dsl
    def option?(name)
      all_options.key?(name.to_s)
    end

    def find_option(name)
      all_options[name.to_s]
    end

    def all_options
      @all_options ||=
        ancestors
        .reverse
        .select { |a| a < Base }
        .each_with_object({}) { |a, memo| memo.merge!(a.options) }
    end

    def options
      @options ||= {}
    end

    def option(*args)
      opts = args.last.is_a?(Hash) ? args.pop : {}

      args.each do |key|
        name = key.to_s
        options[name] = Option.new(name, opts)
      end

      self
    end
  end
end
