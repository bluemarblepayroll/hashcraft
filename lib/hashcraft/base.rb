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
                   :option?,
                   :option_set,
                   :find_option,
                   :key_transformer_object,
                   :value_transformer_object

    def initialize(opts = {}, &block)
      @data = make_default_data

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

    def make_default_data
      option_set.values.each_with_object({}) do |o, memo|
        o.default!(
          memo,
          key_transformer_object,
          value_transformer_object
        )
      end
    end

    def load_opts(opts)
      (opts || {}).each { |k, v| send(k, v) }
    end

    def respond_to_missing?(method_name, include_private = false)
      option?(method_name) || super
    end

    def method_missing(method_name, *arguments, &block)
      if option?(method_name)
        find_option(method_name).value!(
          data,
          arguments.first,
          key_transformer_object,
          value_transformer_object,
          &block
        )
      else
        super
      end
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
  end
end
