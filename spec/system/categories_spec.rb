require 'rails_helper'

RSpec.describe 'Articles', type: :system do
  let(:tag) { create :tag }
  let(:categories) { create_list :category, 2 }
  let(:category) { categories.first }
  let(:nested_category) do
    create :category, :with_children
  end
  let(:child) { nested_category.children.first }
  let(:setting) { create :setting }
  let(:list_size) { 25 }
  before do
    setting
    categories.each do |c|
      create_list :article, list_size, status: 1, category: c, tags: [tag]
    end
    create_list :article, list_size, status: 1, tags: [tag]
  end

  context 'Index' do
    let(:path) { categories_path }
    before do
      visit path
    end

    it 'ページタイトルが適切であること' do
      expect(page).to have_title I18n.t('categories.index.title')
    end

    it '記事を持つカテゴリと親カテゴリ、未分類のリンクが存在すること' do
      create :article, category: child
      visit path

      expect(page).to have_content "#{category.name} (#{category.articles_count})"
      expect(page).to have_content nested_category.name
      expect(page).to have_content "#{I18n.t('utilities.uncategorized')} (#{list_size})"
    end

    it 'ネストしたカテゴリはアコーディオンとして表示されていること' do
      create :article, category: child
      expect(page).to_not have_content "#{child.name} (#{child.articles_count})"

      visit path
      click_on nested_category.name
      expect(page).to have_content "#{child.name} (#{child.articles_count})"
    end
  end

  context 'Show' do
    let(:path) { category_path(category) }
    before do
      visit path
    end

    it 'ページタイトルが適切であること' do
      expect(page).to have_title I18n.t('categories.show.title', name: category.name)
    end

    it 'ソート用のリンクタブが表示されること' do
      expect(page).to have_link I18n.t('utilities.posted_date')
      expect(page).to have_link I18n.t('utilities.updated_date')
      expect(page).to have_link Article.human_attribute_name(:impressions_count)
    end

    it '記事が10件表示されること' do
      articles_cards = page.all '.article-card'

      expect(articles_cards.size).to eq 10
    end

    it '記事の表示件数が20件に変更されること' do
      click_on I18n.t('utilities.per')
      click_on '20'
      articles_cards = all '.article-card'

      expect(articles_cards.size).to eq 20
    end

    it 'status: :draft の記事は表示されないこと' do
      create_list :article, 5
      click_on I18n.t('utilities.per')
      click_on '50'
      articles_cards = all '.article-card'

      expect(articles_cards.size).to eq list_size
    end

    it '記事のカードをクリックすると記事詳細に遷移すること' do
      first('.article-card').click
      first_article = Article.published
                             .post
                             .where(category_id: category.id)
                             .order(published_at: :desc)
                             .first

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
      create :article, category: child
      expect(page).to_not have_content "#{child.name} (#{child.articles_count})"

      visit path
      click_on nested_category.name
      expect(page).to have_content "#{child.name} (#{child.articles_count})"
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
