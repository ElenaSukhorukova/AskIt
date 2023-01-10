# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionTag do
  let(:question_tag) { create(:question_tag) }

  describe 'association' do
    it 'belongs a tag' do
      expect(question_tag.tag).to be_an_instance_of(Tag)
    end

    it 'belongs a question' do
      expect(question_tag.question).to be_an_instance_of(Question)
    end
  end
end
