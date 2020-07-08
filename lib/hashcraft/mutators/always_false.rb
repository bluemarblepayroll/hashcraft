# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Hashcraft
  module Mutators # :nodoc: all
    # Set to false, no matter what.
    class AlwaysFalse
      include Singleton

      def value!(data, key, _value)
        tap { data[key] = false }
      end
    end
  end
end
