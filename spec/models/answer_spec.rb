# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer do
  let(:answer) { create(:answer) }

  it 'returns question\'s body' do
    expect(answer.body).to eq('Answer\'s body')
    expect(answer.body).to be_an_instance_of(String)
  end

  describe 'validation' do
    it 'returns true for the body' do
      expect(answer.body.present?).to be true
    end
  end

  describe 'association' do
    it 'belongs a question' do
      expect(answer.question).to be_an_instance_of(Question)
    end

    it 'belongs a user' do
      expect(answer.user).to be_an_instance_of(User)
    end
  end
end
