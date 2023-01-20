require 'rails_helper'

RSpec.feature "InteracionWithAnswers", type: :feature do
  let!(:answer){ create(:answer) }
  let(:question){ answer.question }
  let(:user){ answer.user }
  before { sign_in(user) }
  
  describe 'edit' do
    scenario 'shows answer\'s edit page after clicking of edit button' do
      visit question_path(question, locale: 'en')
      find_link("edit_answer_#{answer.id}").click

      expect(page).to have_current_path(edit_answer_path(answer, locale: 'en'))
      expect(page).to have_content 'Edit the answer'
    end

    scenario 'shows the answer with a changed body' do
      visit edit_answer_path(answer, locale: 'en')
      
      within("#edit_answer_#{answer.id}") { fill_in :answer_body, with: 'another answer\'s body' }
      click_button(I18n.t('submit.edit'))

      expect(page).to have_content I18n.t('flash.update', model: 'answer')
      expect(page).to have_current_path(question_path(question, locale: 'en'))
      expect(page).to have_content 'another answer\'s body'
    end 
  end

  describe 'new' do
    scenario 'shows the question with a new body' do
      visit question_path(question, locale: 'en')

      within("#new_answer") do
        fill_in :answer_body, with: 'New answer'
      end
      click_button I18n.t('submit.new')
   
      expect(page).to have_current_path(question_path(question, locale: 'en'))
      expect(page).to have_content I18n.t('flash.new', model: 'answer')
      expect(page).to have_content 'New answer'
    end
  end

  describe 'delete' do
    scenario 'questions\' page without a deleted answer after clicking of delete button' do
      visit question_path(question, locale: 'en')
  
      find_button("destroy_answer_#{answer.id}").click

      expect(page).to have_content I18n.t('flash.destroy', model: 'answer')
      expect(page).to have_current_path(question_path(question, locale: 'en'))
      expect(page).not_to have_content answer.body
    end
  end
end
