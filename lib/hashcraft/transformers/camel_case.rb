# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Hashcraft
  module Transformers # :nodoc: all
    # Transform snake-cased to camel-cased string. Example:
    #   date_of_birth => dateOfBirth
    #   DATE_OF_BIRTH => dateOfBirth
    class CamelCase
      include Singleton

      def transform(value, _option)
        return '' if value.to_s.empty?

        name = value.to_s.split('_').collect(&:capitalize).join

        name[0, 1].downcase + name[1..-1]
      end
    end
  end
end
