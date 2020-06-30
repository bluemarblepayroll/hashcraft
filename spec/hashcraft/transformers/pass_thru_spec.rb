# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

RSpec.describe Hashcraft::Transformers::PassThru do
  subject { described_class.instance }

  specify '#transform returns what was passed in' do
    value  = 'something'
    option = nil

    expect(subject.transform(value, option)).to eq(value)
  end
end
