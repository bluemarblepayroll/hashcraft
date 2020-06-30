# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Hashcraft
  module Mutators
    # When a hash's key is an arry then this mutator can be used to push a new value on the
    # respective array.
    class Array
      include Singleton

      def value!(data, key, value)
        data[key] ||= []
        data[key] << value

        self
      end
    end
  end
end
