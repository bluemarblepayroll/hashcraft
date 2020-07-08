# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Hashcraft
  module Transformers # :nodoc: all
    # Transform snake-cased to pascal-cased string. Example:
    #   date_of_birth => DateOfBirth
    #   DATE_OF_BIRTH => DateOfBirth
    class PascalCase
      include Singleton

      def transform(value, _option)
        return '' if value.to_s.empty?

        value.to_s.split('_').collect(&:capitalize).join
      end
    end
  end
end
