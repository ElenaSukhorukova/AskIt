# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag do
  let(:tag) { create(:tag) }

  it 'returns tag\'s title' do
    expect(tag.title).to be_an_instance_of(String)
  end

  describe 'validation' do
    it 'returns true for the title' do
      expect(tag.title.present?).to be true
    end

    it 'returns true for the invalid tag' do
      tag = create(:tag)
      another_tag = described_class.new title: 'tag\'s name'
      expect(another_tag.invalid?).to be true
    end

    it 'returns false for the valid tag' do
      tag = create(:tag)
      another_tag = described_class.new title: 'tag\'s name 2'
      expect(another_tag.invalid?).to be false
    end

    it { is_expected.to have_many :questions }
  end
end
