# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Hashcraft
  # Defines a method and corresponding attribute for a craftable class.
  class Option
    attr_reader :craft,
                :default,
                :eager,
                :key,
                :mutator,
                :name

    def initialize(name, opts = {})
      raise ArgumentError, 'name is required' if name.to_s.empty?

      @craft          = opts[:craft]
      @default        = opts[:default]
      @eager          = opts[:eager] || false
      @internal_meta  = (opts[:meta] || {}).symbolize_keys
      @key            = opts[:key].to_s
      @mutator        = MutatorRegistry.resolve(opts[:mutator])
      @name           = name.to_s

      freeze
    end

    def meta(key)
      internal_meta[key.to_s.to_sym]
    end

    def default!(data)
      return self unless eager

      data[name] = default

      self
    end

    def value!(data, value, &block)
      value = craft_value(value, &block)

      mutator.value!(data, name, value)

      self
    end

    private

    attr_reader :internal_meta

    def craft_value(value, &block)
      craft ? craft.new(value, &block) : value
    end
  end
end
