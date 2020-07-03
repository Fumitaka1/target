# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'bookmark', type: :system do
  before do
    User.create!(name: 'sample_user',
                 email: 'sample_user@example.go',
                 password: 'password')

    create(:post, title: 'bookmark test')
  end
  it 'ブックマークに追加して解除する' do
    visit root_path
    click_on 'ログイン'
    fill_in 'user[email]', with: 'sample_user@example.go'
    fill_in 'user[password]', with: 'password'
    click_button 'ログイン'

    visit root_path
    click_on 'bookmark test'
    expect(page).to have_button 'ブックマーク'
    click_on 'ブックマーク'
    expect(page).to have_button 'ブックマークを取り消す'
    click_on 'ブックマークを取り消す'
  end
end
