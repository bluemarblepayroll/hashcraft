# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'mutators/array'
require_relative 'mutators/hash'
require_relative 'mutators/property'

module Hashcraft
  # Singleton that knows how to register and retrieve mutator instances.
  class MutatorRegistry < Generic::Registry
    def initialize
      super(
        'array' => Mutators::Array.instance,
        'hash' => Mutators::Hash.instance,
        'property' => Mutators::Property.instance,
        '' => Mutators::Property.instance
      )
    end
  end
end
