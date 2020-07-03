# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'post', type: :system do
  before do
    User.create!(name: 'sample_user',
                 email: 'sample_user@example.go',
                 password: 'password')
  end
  it '新規投稿した記事を編集、削除する' do
    visit root_path
    click_on 'ログイン'
    fill_in 'user[email]', with: 'sample_user@example.go'
    fill_in 'user[password]', with: 'password'
    click_button 'ログイン'
    visit root_path
    click_on '投稿'
    expect(page).to have_content '新規投稿'
    fill_in 'post[title]', with: 'example title'
    fill_in 'post[content]', with: 'example content'
    attach_file 'post[image]', "#{Rails.root}/spec/factories/sample_image.png"
    click_button '投稿'

    expect(page).to have_selector '.post_title'
    expect(page).to have_content 'example title'
    expect(page).to have_selector '.post_contents'
    expect(page).to have_content 'example content'
    expect(page).to have_selector '.post_image'

    click_on '編集'
    fill_in 'post[title]', with: 'changed title'
    fill_in 'post[content]', with: 'changed content'
    check '画像を削除'
    click_button '投稿'

    expect(page).to have_content 'changed title'
    expect(page).to have_content 'changed content'
    expect(page).to have_no_selector '.image'

    page.accept_confirm('本当に削除しますか？') do
      click_on '削除'
    end
    expect(page).to have_content '削除しました。'

    expect(Post.find_by(title: 'changed title')).to eq(nil)
  end
end
