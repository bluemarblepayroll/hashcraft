# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Hashcraft
  # Dictionary structure defining how we want to organize options.  Basically a type-insensitive
  # hash where each key is the options name.
  # All keys are #to_s evaluated in order to achieve the type-insensitivity.
  class OptionSet
    extend Forwardable

    attr_reader :map

    def_delegators :map, :values

    def initialize
      @map = {}

      freeze
    end

    def exist?(name)
      !find(name).nil?
    end

    def find(name)
      @map[name.to_s]
    end

    def add(option)
      @map[option.name] = option
    end

    def merge!(option_set)
      map.merge!(option_set.map)

      self
    end
  end
end
