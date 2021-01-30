require 'rails_helper'

RSpec.describe 'Tags', type: :system do
  let(:tags) { create_list :tag, 2 }
  let(:tag) { tags.first }
  let(:categories) { create_list :category, 2 }
  let(:category) { create :category }
  let(:nested_category) do
    create :category, :with_children
  end
  let(:child_category) { nested_category.children.first }
  let(:setting) { create :setting }
  let(:list_size) { 25 }
  before do
    setting
    tags.each do |t|
      create_list :article, list_size, status: 1, category: category, tags: [t]
    end
  end

  context 'Index' do
    let(:path) { tags_path }
    before do
      visit path
    end

    it 'ページタイトルが適切であること' do
      expect(page).to have_title I18n.t('tags.index.title')
    end

    it '記事を持つタグへのリンク一覧が存在すること' do
      tags.each do |t|
        click_on "#{t.name} (#{t.articles_count})"

        expect(current_path).to eq tag_path(t)
        visit path
      end
    end
  end

  context 'Show' do
    let(:path) { tag_path(tag) }
    let(:first_article) do
      tag.articles
         .published
         .post
         .order(published_at: :desc)
         .first
    end
    before do
      visit path
    end

    it 'ページタイトルが適切であること' do
      expect(page).to have_title I18n.t('tags.show.title', name: tag.name)
    end

    it 'ソート用のリンクタブが表示されること' do
      expect(page).to have_link I18n.t('utilities.posted_date')
      expect(page).to have_link I18n.t('utilities.updated_date')
      expect(page).to have_link Article.human_attribute_name(:impressions_count)
    end

    it '記事が10件表示されること' do
      expect(all('.article-card').size).to eq 10
    end

    it '記事の表示件数が20件に変更されること' do
      click_on I18n.t('utilities.per')
      click_on '20'

      expect(all('.article-card').size).to eq 20
    end

    it 'status: :draft の記事は表示されないこと' do
      create_list :article, 5
      click_on I18n.t('utilities.per')
      click_on '50'

      expect(all('.article-card').size).to eq list_size
    end

    it '記事のカードをクリックすると記事詳細に遷移すること' do
      first('.article-card').click

      expect(current_path).to eq article_path(first_article)
    end

    it '記事カード内のカテゴリをクリックするとカテゴリの詳細画面に遷移すること' do
      first('.articles-category-link').click

      expect(current_path).to eq category_path(category)
    end

    it '記事カード内のタグをクリックするとタグの詳細画面に遷移すること' do
      first('.articles-tag-link').click

      expect(current_path).to eq tag_path(tag)
    end

    it 'カテゴリ一覧のサイドメニューが表示されていること' do
      expect(page).to have_selector '#categories-side-menu'

      click_on "#{category.name} (#{category.articles_count})"
      expect(current_path).to eq category_path(category)
    end

    it 'サイドメニュー内のネストしたカテゴリはアコーディオンとして表示されていること' do
      create :article, category: child_category
      expect(page).to_not have_content "#{child_category.name} (#{child_category.articles_count})"

      visit path
      click_on nested_category.name
      click_on "#{child_category.name} (#{child_category.articles_count})"
      expect(current_path).to eq category_path(child_category)
    end

    it 'タグ一覧のサイドメニューが表示されていること' do
      expect(page).to have_selector '#tags-side-menu'

      click_on "#{tag.name} (#{tag.articles_count})"
      expect(current_path).to eq tag_path(tag)
    end

    it '最近人気の記事一覧のサイドメニューが設定により表示・非表示を切り替えられること' do
      expect(page).to_not have_selector '#recent-articles-side-menu'

      setting.update anable_recent_popular: true
      visit path
      expect(page).to have_selector '#recent-articles-side-menu'
    end
  end
end
