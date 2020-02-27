require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'edits his answer' do
      within "div#question_id_#{question.id}" do
        click_on 'Edit question'

        fill_in 'Question title', with: 'edited question title'
        fill_in 'Question body', with: 'edited question body'
        click_on 'Save'
        wait_for_ajax

        expect(page).to have_content 'edited question title'
        expect(page).to have_selector 'textarea', text: 'edited question body', visible: false
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      within "div#question_id_#{question.id}" do
        click_on 'Edit question'

        fill_in 'Question title', with: ''
        fill_in 'Question body', with: ''
        click_on 'Save'

        expect(page).to_not have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end
  end

  scenario "tries to edit other user's question" do
    sign_in(user2)
    visit questions_path

    expect(page).to_not have_link 'Edit question'
  end
end