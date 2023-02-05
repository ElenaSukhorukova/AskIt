# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'InteracionWithQuestions' do
  let!(:question) { create(:question) }
  let(:user) { question.user }

  before { sign_in(user) }

  describe 'edit' do
    it 'shows question\'s edit page after clicking of edit link' do
      visit question_path(question, locale: 'en')
      find_link("edit_question_#{question.id}").click

      expect(page).to have_current_path(edit_question_path(question, locale: 'en'))
      expect(page).to have_content 'Edit the question'
    end

    it 'shows the question with a changed body' do
      visit edit_question_path(question, locale: 'en')

      within("#edit_question_#{question.id}") { fill_in :question_body, with: 'another body' }
      click_button(I18n.t('submit.edit'))

      expect(page).to have_content I18n.t('flash.update', model: 'question')
      expect(page).to have_current_path(question_path(question, locale: 'en'))
      expect(page).to have_content 'another body'
    end
  end

  describe 'new' do
    it 'shows question\'s new page after clicking of new button' do
      visit questions_path

      click_link I18n.t('link.new', model: 'question')

      expect(page).to have_current_path(new_question_path(locale: 'en'))
      expect(page).to have_content 'A new question'
    end

    it 'shows the question with a new body' do
      visit new_question_path

      within('#new_question') do
        fill_in :question_title, with: 'New title'
        fill_in :question_body, with: 'New question'
      end
      click_button I18n.t('submit.new')

      expect(page).to have_current_path(question_path(Question.last, locale: 'en'))
      expect(page).to have_content I18n.t('flash.new', model: 'question')
      expect(page).to have_content 'New title'
    end
  end

  describe 'delete' do
    it 'questions\' page without a deleted question after clicking of delete button' do
      visit question_path(question, locale: 'en')

      find_button("destroy_question_#{question.id}").click

      expect(page).to have_content I18n.t('flash.destroy', model: 'question')
      expect(page).to have_current_path(questions_path(locale: 'en'))
      expect(page).not_to have_content question.title
    end
  end

  it 'shows question\'s page after clicking of show link' do
    visit questions_path

    find_link("question_#{question.id}").click

    expect(page).to have_current_path(question_path(question, locale: 'en'))
    expect(page).to have_content question.title
  end
end
