# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'dsl'

module Hashcraft
  # Super-class for craftable objects.
  class Base
    extend Dsl
    extend Forwardable

    def_delegators :'self.class',
                   :option_set,
                   :find_option,
                   :key_transformer_to_use,
                   :value_transformer_to_use

    def initialize(opts = {}, &block)
      @data = {}

      load_default_data
      load_opts(opts)

      return unless block_given?

      if block.arity == 1
        yield self
      else
        instance_eval(&block)
      end
    end

    def to_h
      data.each_with_object({}) do |(key, value), memo|
        method = value.is_a?(Array) ? :evaluate_values! : :evaluate_value!

        send(method, memo, key, value)
      end
    end

    private

    attr_reader :data

    def load_default_data
      option_set.each { |option| default!(option) }
    end

    def load_opts(opts)
      (opts || {}).each { |k, v| send(k, v) }
    end

    def evaluate_values!(data, key, values)
      data[key] ||= []

      values.each do |value|
        data[key] << (value.is_a?(Hashcraft::Base) ? value.to_h : value)
      end

      self
    end

    def evaluate_value!(data, key, value)
      data[key] = (value.is_a?(Hashcraft::Base) ? value.to_h : value)

      self
    end

    def default!(option)
      return self unless option.eager?

      key   = hash_key(option)
      value = value_transformer_to_use.transform(option.default.dup, option)

      data[key] = value

      self
    end

    def value!(option, value, &block)
      key   = hash_key(option)
      value = option.craft_value(value, &block)
      value = value_transformer_to_use.transform(value, option)

      option.value!(data, key, value)

      self
    end

    def hash_key(option)
      key_transformer_to_use.transform(option.hash_key, option)
    end
  end
end
