# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Hashcraft
  module Transformers
    # Default transformer, simply returns the value passed in.
    class PassThru
      include Singleton

      def transform(value, _option)
        value
      end
    end
  end
end
