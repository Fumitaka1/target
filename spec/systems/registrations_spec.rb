# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'registration', type: :system do
  it '新規登録した後、アカウントを変更して削除' do
    visit root_path
    click_on '新規登録'
    fill_in 'user[name]', with: 'sample_user'
    fill_in 'user[email]', with: 'sample_user@example.go'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button '新規登録'
    expect(page).to have_content 'アカウント登録が完了しました。'

    click_on 'sample_user'
    expect(page).to have_content 'sample_userのマイページ'
    click_on 'アカウント変更'
    expect(page).to have_content 'アカウント変更'
    fill_in 'user[name]', with: 'test_user'
    fill_in 'user[email]', with: 'test_user@someting.com'
    fill_in 'user[password]', with: '12345678'
    fill_in 'user[password_confirmation]', with: '12345678'
    fill_in 'user[current_password]', with: 'password'
    attach_file 'user[icon]', "#{Rails.root}/spec/factories/sample_icon.jpg"
    click_button '変更'
    expect(page).to have_content 'アカウント情報を変更しました。'

    click_on 'test_user'
    click_on 'アカウント変更'
    page.accept_confirm('本当に削除しますか？') do
      click_on 'アカウント削除'
    end
    expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
  end
end
