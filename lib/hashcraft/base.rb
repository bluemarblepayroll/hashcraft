# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'compiler'
require_relative 'dsl'

module Hashcraft
  # Super-class for craftable objects.
  class Base
    extend Dsl
    extend Forwardable

    def_delegators :'self.class', :option?, :option_set, :find_option

    def initialize(opts = {}, &block)
      @data = {}

      load_defaults
      load_options(opts)

      return unless block_given?

      if block.arity == 1
        yield self
      else
        instance_eval(&block)
      end
    end

    def to_h(key_transformer: nil, value_transformer: nil)
      Compiler.new(
        option_set,
        key_transformer: key_transformer,
        value_transformer: value_transformer
      ).evaluate!(data)
    end

    private

    attr_reader :data

    def load_defaults
      option_set.values.each { |o| o.default!(data) }
    end

    def load_options(opts = {}, &block)
      (opts || {}).each do |key, value|
        option = find_option(key)

        raise NoMethodError, "#{key} is not an option and is therefore not a method" unless option

        option.value!(data, value, &block)
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      option?(method_name) || super
    end

    def method_missing(method_name, *arguments, &block)
      if option?(method_name)
        load_options({ method_name => arguments[0] }, &block)
      else
        super
      end
    end
  end
end
