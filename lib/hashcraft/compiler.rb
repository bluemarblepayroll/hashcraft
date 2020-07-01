# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'dsl'

module Hashcraft
  # This class understands how to traverse an option chain and output a hash.
  class Compiler
    attr_reader :key_transformer, :option_set, :value_transformer

    def initialize(option_set, key_transformer: nil, value_transformer: nil)
      raise ArgumentError, 'option_set is required' unless option_set

      @option_set        = option_set
      @key_transformer   = TransformerRegistry.resolve(key_transformer)
      @value_transformer = TransformerRegistry.resolve(value_transformer)

      freeze
    end

    def evaluate!(data)
      data.each_with_object({}) do |(key, value), memo|
        option = option_set.find(key)

        evaluate_single!(memo, option, value)
      end
    end

    private

    attr_reader :data

    def evaluate_single!(data, option, value)
      key             = option.key.empty? ? option.name : option.key
      transformed_key = key_transformer.transform(key, option)

      method = value.is_a?(Array) ? :evaluate_values! : :evaluate_value!

      send(method, option, data, transformed_key, value)

      self
    end

    def evaluate_values!(option, data, key, values)
      data[key] ||= []

      values.each do |value|
        data[key] <<
          if value.is_a?(Hashcraft::Base)
            value.to_h(
              key_transformer: key_transformer,
              value_transformer: value_transformer
            )
          else
            value_transformer.transform(value, option)
          end
      end

      self
    end

    def evaluate_value!(option, data, key, value)
      data[key] =
        if value.is_a?(Hashcraft::Base)
          value.to_h(
            key_transformer: key_transformer,
            value_transformer: value_transformer
          )
        else
          value_transformer.transform(value, option)
        end

      self
    end
  end
end
