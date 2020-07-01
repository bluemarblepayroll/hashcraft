# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

RSpec.describe Hashcraft::Transformers::PascalCase do
  subject { described_class.instance }

  {
    '' => '',
    'frank_rizzo' => 'FrankRizzo',
    'frank rizzo' => 'Frank rizzo',
    'FRANK_RIZZO' => 'FrankRizzo'
  }.each do |input, output|
    specify "#{input} => #{output}" do
      expect(subject.transform(input, nil)).to eq(output)
    end
  end
end
