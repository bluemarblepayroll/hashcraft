# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'mutators/always_false'
require_relative 'mutators/always_true'
require_relative 'mutators/array'
require_relative 'mutators/flat_array'
require_relative 'mutators/hash'
require_relative 'mutators/property'

module Hashcraft
  # Singleton that knows how to register and retrieve mutator instances.
  class MutatorRegistry < Generic::Registry # :nodoc:
    def initialize
      super(
        '' => Mutators::Property.instance,
        'always_false' => Mutators::AlwaysFalse.instance,
        'always_true' => Mutators::AlwaysTrue.instance,
        'array' => Mutators::Array.instance,
        'flat_array' => Mutators::FlatArray.instance,
        'hash' => Mutators::Hash.instance,
        'property' => Mutators::Property.instance
      )
    end
  end
end
