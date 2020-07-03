# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'comment', type: :system do
  before do
    User.create!(name: 'sample_user',
                 email: 'sample_user@example.go',
                 password: 'password')

    create(:post)
  end
  it 'コメントを投稿して編集、削除する' do
    visit root_path
    click_on 'ログイン'
    fill_in 'user[email]', with: 'sample_user@example.go'
    fill_in 'user[password]', with: 'password'
    click_button 'ログイン'

    visit root_path
    click_on Post.take.title.to_s
    fill_in 'comment[content]', with: 'これはテストコメント。'
    click_button '投稿'
    expect(page).to have_content 'これはテストコメント。'

    click_on '編集'
    fill_in 'comment[content]', with: 'これは編集されたコメント。'
    click_button '投稿'
    expect(page).to have_content 'これは編集されたコメント。'

    page.accept_confirm('本当に削除しますか？') do
      click_on '削除'
    end
    expect(page).to have_content '削除しました。'
    expect(Comment.find_by(content: 'これは編集されたコメント。')).to eq(nil)
  end
end
