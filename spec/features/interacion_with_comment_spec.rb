# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'InteracionWithComments' do
  let!(:comment) { create(:comment) }
  let(:question) { comment.commentable }

  before do
    user = comment.user
    sign_in(user)
  end

  describe 'new' do
    it 'shows the question with a new comment' do
      user = comment.user
      sign_in(user)

      visit question_path(question, locale: 'en')

      find_link("#{question.id}_questionComments").click
      within('#new_comment') { fill_in :comment_body, with: 'New comment for a question' }
      click_button I18n.t('comment.new.submit')
      find_link("#{question.id}_questionComments").click

      expect(page).to have_current_path(question_path(question, locale: 'en'))
      expect(page).to have_content I18n.t('flash.new', model: 'comment')
      expect(page).to have_content 'New comment for a question'
    end
  end

  describe 'delete', :last do
    it 'questions\' page without a deleted comment after clicking of delete button' do
      user = comment.user
      sign_in(user)

      visit question_path(question, locale: 'en')
      find_link("#{question.id}_questionComments").click
      debugger
      # find_button(I18n.t('comment.delete.submit')).click
      # find_link("#{question.id}_questionComments").click

      # expect(page).to have_content I18n.t('flash.destroy', model: 'comment')
      # expect(page).to have_current_path(questions_path(locale: 'en'))
      # expect(page).not_to have_content comment.body
    end
  end
end
