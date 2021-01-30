require 'rails_helper'

RSpec.describe 'Contacts', type: :system do
  let(:setting) { create :setting }
  let(:path) { root_path }
  let(:global_menus) do
    [
      { label: I18n.t('utilities.all_posts'), path: root_path },
      { label: Category.model_name.human, path: categories_path },
      { label: Tag.model_name.human, path: tags_path },
      { label: Contact.model_name.human, path: new_contact_path }
    ]
  end
  before do
    setting
    visit path
  end

  context 'Header' do
    it 'サイトタイトルをクリックすると root に遷移すること' do
      expect(page).to have_content setting.site_title

      click_on setting.site_title
      expect(current_path).to eq path
    end

    it 'ヘッダー内に規定のリンクが存在すること' do
      within '#global-header' do
        global_menus.each do |menu|
          expect(page).to have_content menu[:label]

          click_on menu[:label]
          expect(current_path).to eq menu[:path]
        end
      end
    end
  end

  context 'Footer' do
    let(:share_link_classes) do
      %w[copy-url-link line-share-link facebook-share-link twitter-share-link]
    end

    it 'フッター内に規定のリンクが存在すること' do
      within '#global-footer' do
        global_menus.each do |menu|
          expect(page).to have_content menu[:label]

          click_on menu[:label]
          expect(current_path).to eq menu[:path]
        end
      end
    end

    it 'フッター内にSNSシェアボタンが存在すること' do
      within '#global-footer' do
        share_link_classes.each do |class_name|
          expect(page).to have_css ".#{class_name}"
        end
      end
    end
  end

  context 'Component' do
    it '400px以上スクロールするとTOPへスクロールするボタンが表示されること' do
      create_list :article, 10, status: 1
      visit path
      expect(page).to_not have_selector '#to-top-button'

      execute_script 'window.scrollTo(0, 400)'
      expect(page).to have_selector '#to-top-button'
    end
  end
end
