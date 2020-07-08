# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Hashcraft
  module Mutators
    # If the value is an array then concat, if it is not an array then push.
    class FlatArray
      include Singleton

      def value!(data, key, value)
        data[key] ||= []

        # Prefixed Array with double colons to not get confused with our Array mutator class.
        if value.is_a?(::Array)
          data[key] += value
        else
          data[key] << value
        end

        self
      end
    end
  end
end
