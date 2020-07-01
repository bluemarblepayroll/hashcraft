# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'registry'
require_relative 'transformers/camel_case'
require_relative 'transformers/pascal_case'
require_relative 'transformers/pass_thru'

module Hashcraft
  # Singleton that knows how to register and retrieve transformer instances.
  class TransformerRegistry < Registry
    def initialize
      super(DEFAULT_MAP)
    end

    DEFAULT_MAP = {
      'camel_case' => Transformers::CamelCase.instance,
      'pascal_case' => Transformers::PascalCase.instance,
      'pass_thru' => Transformers::PassThru.instance,
      '' => Transformers::PassThru.instance
    }.freeze

    private_constant :DEFAULT_MAP
  end
end
