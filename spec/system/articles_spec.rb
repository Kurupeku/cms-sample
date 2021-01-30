require 'rails_helper'

RSpec.describe 'Articles', type: :system do
  let(:tag) { create :tag }
  let(:category) { create :category }
  let(:nested_category) do
    create :category, :with_children
  end
  let(:child_category) { nested_category.children.first }
  let(:setting) { create :setting }
  let(:list_size) { 25 }
  before do
    setting
  end

  context 'Index' do
    let(:path) { root_path }
    before do
      create_list :article, list_size, status: 1, category: category, tags: [tag]
      visit path
    end

    it 'ページタイトルが適切であること' do
      expect(page).to have_title I18n.t('articles.index.title')
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
      child = nested_category.children.first
      create :article, category: child
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

  context 'Show' do
    let(:body) { page.find 'body' }
    let(:article) { create :article, status: 1, category: category, tags: [tag] }
    let(:comment_parent_label) { Comment.human_attribute_name :parent_id }
    let(:comment_submit) { find '#comment-form-submit' }
    let(:parent_comment) { create :comment, article: article }
    let(:child_comment) { create :comment, article: article, parent: parent_comment }
    let(:path) { article_path(article) }
    before do
      visit path
    end

    it 'ページタイトルが適切であること' do
      expect(page).to have_title article.title
    end

    it 'カバー画像が登録されていれば表示されること' do
      expect(page).to_not have_selector '.article-cover-img'

      filename = 'sample_cover_1.jpg'
      io = File.open Rails.root.join 'public', filename
      article.cover.attach io: io, filename: filename, content_type: 'image/jpeg'
      visit path
      expect(page).to have_selector '.article-cover-img'
    end

    it 'コメントが表示されていること' do
      create :comment, :with_nested_children, article: article
      visit path
      comment_list = all '.article-comment'

      expect(comment_list.size).to eq 3
    end

    it 'コメントのリプライ先リンクをクリックすると内容がダイアログで表示される' do
      child_comment
      visit path
      find("#comment-#{child_comment.number}").find('.reply-preview-link').click

      expect(page).to have_css '.reply-preview-dialog'
    end

    it 'コメントフォームの :parent_id が 規定の選択肢になっていること' do
      create_list :comment, 5, article: article
      visit path
      options = [
        I18n.t('utilities.none'), *article.comments_choices.map { |ch| ch[0] }
      ]

      expect(page).to have_select comment_parent_label,
                                  options: options
    end

    it 'コメントの返信リンクをクリックすると :parent_id にクリックしたコメントの :number が入力される' do
      create_list :comment, 5, article: article
      visit path
      first_comment = article.comments.first
      find("#comment-#{first_comment.number}").find('.reply-to-link').click

      expect(page).to have_select comment_parent_label,
                                  selected: "No.#{first_comment.number}"
    end

    it 'コメントフォームの :content が入力されていないと submit が disabled になっていること' do
      fill_in I18n.t('utilities.your_name'), with: 'テスト'
      body.click

      expect(comment_submit).to be_disabled
    end

    it 'コメントフォームからコメントを作成できること' do
      fill_in I18n.t('utilities.your_name'), with: 'テスト'
      fill_in Comment.human_attribute_name(:content), with: 'テスト'
      body.click

      expect { comment_submit.click }.to change {
        all('.article-comment').size
      }.by(1)
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
      expect(page).to have_content "#{child_category.name} (#{child_category.articles_count})"
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

    it '目次がサイドメニューに表示されていること' do
      expect(page).to have_selector '#article-toc'

      expect(all('.toc-link')&.size&.positive?).to be_truthy
    end
  end
end
