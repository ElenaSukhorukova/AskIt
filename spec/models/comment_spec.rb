# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment do
  let(:comment) { create(:comment) }

  it 'returns comment\'s body' do
    expect(comment.body).to eq('Comment\'s body')
    expect(comment.body).to be_an_instance_of(String)
  end

  describe 'validation' do
    it 'returns true for the body' do
      expect(comment.body.present?).to be true
    end

    it 'returns true for the invalid comment' do
      comment.body = 'H'
      expect(comment.invalid?).to be true
    end
  end

  describe 'association' do
    it 'belongs a user' do
      expect(comment.user).to be_an_instance_of(User)
    end

    it 'belongs a question or an answer' do
      expect(comment.commentable).to be_an_instance_of(Question).or be_an_instance_of(Answer)
    end
  end
end
