# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question do
  let(:question) { create(:question) }

  it 'returns question\'s body' do
    expect(question.body).to eq("Question's body")
    expect(question.body).to be_an_instance_of(String)
  end

  it 'returns question\'s body' do
    expect(question.title).to eq("Question's title")
  end

  describe 'validation' do
    it 'returns true for the body' do
      expect(question.body.present?).to be true
    end

    it 'returns true for the title' do
      expect(question.title.present?).to be true
    end
  end

  describe 'association' do
    it 'belongs a user' do
      expect(question.user).to be_an_instance_of(User)
    end

    it { is_expected.to have_many :answers }
    it { is_expected.to have_many :comments }
    it { is_expected.to have_many :tags }
  end
end
