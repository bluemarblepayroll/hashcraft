# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'option'
require_relative 'transformer_registry'

module Hashcraft
  # The class API used to define options for a craftable class.  Each class stores its own
  # OptionSet instance along with materializing one for its
  # inheritance chain (child has precedence.)
  module Dsl
    attr_reader :local_key_transformer,
                :local_value_transformer

    def key_transformer(name)
      tap { @local_key_transformer = TransformerRegistry.resolve(name) }
    end

    def value_transformer(name)
      tap { @local_value_transformer = TransformerRegistry.resolve(name) }
    end

    def key_transformer_to_use
      return @key_transformer_to_use if @key_transformer_to_use

      @closest_key_transformer =
        ancestors.select { |a| a < Base }
                 .find(&:local_key_transformer)
                 &.local_key_transformer || Transformers::PassThru.instance
    end

    def value_transformer_to_use
      return @value_transformer_to_use if @value_transformer_to_use

      @closest_value_transformer =
        ancestors.select { |a| a < Base }
                 .find(&:local_value_transformer)
                 &.local_value_transformer || Transformers::PassThru.instance
    end

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
        .each_with_object(Generic::Dictionary.new) { |a, memo| memo.merge!(a.local_option_set) }
    end

    def local_option_set
      @local_option_set ||= Generic::Dictionary.new(key: :name)
    end
  end
end
