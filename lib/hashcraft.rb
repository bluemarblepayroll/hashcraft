# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'forwardable'
require 'singleton'

# Monkey-patching core libraries
require_relative 'hashcraft/core_ext/hash'
Hash.include Hashcraft::CoreExt::Hash

# General tooling
require_relative 'hashcraft/generic'

require_relative 'hashcraft/base'
require_relative 'hashcraft/mutator_registry'
require_relative 'hashcraft/transformer_registry'
