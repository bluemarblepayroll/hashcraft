# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'
require 'grid_examples'

RSpec.describe Hashcraft::Base do
  describe '#respond_to?' do
    it 'returns false for non-existant options/methods' do
      subject = Grid.new

      expect(subject.respond_to?(:non_existant)).to be false
    end

    it 'returns true for existant options' do
      subject = Grid.new

      expect(subject.respond_to?(:name)).to be true
    end

    it 'returns true for existant methods' do
      subject = Grid.new

      expect(subject.respond_to?(:to_h)).to be true
    end
  end

  it 'raises NoMethodError for non-existant options using block-based configuration' do
    expect do
      Grid.new do
        non_existant 'something'
      end
    end.to raise_error(NoMethodError)
  end

  it 'raises NoMethodError for non-existant options using constructor-based configuration' do
    expect { Grid.new(non_existant: 'something') }.to raise_error(NoMethodError)
  end

  describe '#to_h' do
    describe 'craft using local block variable and external scope access' do
      let(:what) { 'patients' }

      subject do
        Grid.new name: 'PatientsGrid' do |g|
          g.header do |h|
            h.message "Use this grid to search #{what}..."
          end
        end
      end

      it 'leverages declared Hashcraft::Base subclass' do
        expected = {
          'message' => 'Use this grid to search patients...',
          'title' => 'Untitled Grid'
        }

        actual = subject.to_h['header']

        expect(actual).to eq(expected)
      end
    end

    describe 'eager/default' do
      it 'is included and set to default' do
        hash = Grid.new.to_h

        expect(hash['max_width']).to eq('350px')
      end

      it 'is overridden when explicitly defined' do
        hash = Grid.new(max_width: '500px').to_h

        expect(hash['max_width']).to eq('500px')
      end
    end

    describe 'hash mutator' do
      subject do
        Grid.new name: 'PatientsGrid' do
          context patient_id: 123
          context practice_id: 456

          column header: 'ID #' do
            context visible: true
            context align: :center
          end
        end
      end

      it 'merges multiple values into a hash' do
        expected_grid_context = { patient_id: 123, practice_id: 456 }
        actual_grid_context   = subject.to_h['context']

        expect(actual_grid_context).to eq(expected_grid_context)
      end

      it 'merges multiple nested values into a nested hash' do
        expected_grid_context = { align: :center, visible: true }
        actual_grid_context   = subject.to_h['columns'][0]['context']

        expect(actual_grid_context).to eq(expected_grid_context)
      end
    end

    describe 'array mutator without nested craft' do
      subject do
        Grid.new name: 'PatientsGrid' do
          child 'ChartsGrid'
          child 'NotesGrid'
        end
      end

      it 'pushes all values one main array' do
        expected = %w[ChartsGrid NotesGrid]

        actual = subject.to_h['children']

        expect(actual).to eq(expected)
      end
    end

    describe 'array mutator with nested craft' do
      subject do
        Grid.new name: 'MoviesGrid' do
          column header: 'ID #' do
            content property: :id
          end

          column header: 'Name' do
            content property: :first
            content property: :last
          end
        end
      end

      it 'pushes multiple values into an array (also nested array mutators)' do
        expected = [
          {
            'header' => 'ID #',
            'contents' => [
              { 'property' => :id }
            ]
          },
          {
            'header' => 'Name',
            'contents' => [
              { 'property' => :first },
              { 'property' => :last }
            ]
          }
        ]

        actual = subject.to_h['columns']

        expect(actual).to eq(expected)
      end
    end
  end
end
