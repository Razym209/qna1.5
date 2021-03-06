require 'rails_helper'

feature 'User can delete his own question' do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user1) }

  scenario 'user1 try to delete user1 question' do
    sign_in(user1)

    visit questions_path
    click_on 'Delete'

    expect(page).to have_content "you successfully deleted"
    expect(page).to have_no_content question.title
    expect(page).to have_no_content question.body
  end

  scenario 'user2 try to delete user1 question' do
    sign_in(user2)

    visit questions_path

    expect(page).to have_no_content "Delete"
    expect(page).to have_content question.title
    expect(page).to have_no_content question.body
  end

  scenario 'unauthenticated user can not delete question' do
    visit questions_path

    expect(page).to have_no_content "Delete"
    expect(page).to have_content question.title
    expect(page).to have_no_content question.body
  end
end

