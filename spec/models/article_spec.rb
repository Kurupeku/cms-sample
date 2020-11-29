require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Article, type: :model do
  context 'バリデーションの動作確認' do
    it 'title, slug がともに有効な値の場合、有効になる' do
      article = build :article
      expect(article).to be_valid
    end

    it 'title が未定義の場合、無効になる' do
      article = build :article, title: nil
      article.valid?
      expect(article.errors.key?(:title)).to be true
    end

    it 'title が空文字の場合、無効になる' do
      article = build :article, title: ''
      article.valid?
      expect(article.errors.key?(:title)).to be true
    end

    it 'slug が未定義の場合、無効になる' do
      article = build :article, slug: nil
      article.valid?
      expect(article.errors.key?(:slug)).to be true
    end

    it 'slug が空文字の場合、無効になる' do
      article = build :article, slug: ''
      article.valid?
      expect(article.errors.key?(:slug)).to be true
    end

    it 'slug がすでに存在する文字列の場合、無効になる' do
      past_article = create :article
      article = build :article, slug: past_article.slug
      article.valid?
      expect(article.errors.key?(:slug)).to be true
    end

    it 'category がサブカテゴリーを持つ場合、関連付けができない' do
      parent_category = create :category, :with_children
      article = build :article, category: parent_category
      article.valid?
      expect(article.errors.key?(:base)).to be true
    end
  end

  context 'カウンターキャッシュの動作確認' do
    it '関連する Comment が作成された際にカウンターが増える' do
      article = create :article
      expect do
        create :comment, article: article
      end.to change { article.comments_count }.by 1
    end
  end

  context '依存削除の動作確認' do
    it 'Article インスタンスが削除された場合、関連する Comment も削除される' do
      article = create :article
      create_list :comment, 3, article: article
      expect do
        article.destroy
      end.to change { Comment.all.size }.by(-3)
    end

    it 'Article インスタンスが削除された場合、Tag との中間テーブルのレコードも削除される' do
      article = create :article
      create_list :tag, 3, articles: [article]
      expect do
        article.destroy
      end.to change { ArticleTagAttachment.all.size }.by(-3)
    end
  end
end

# == Schema Information
#
# Table name: articles
#
#  id                :bigint           not null, primary key
#  article_type      :integer          default("post"), not null
#  comments_count    :integer          default(0), not null
#  impressions_count :integer          default(0), not null
#  opening_sentence  :string           default("")
#  published_at      :datetime
#  slug              :string           not null
#  status            :integer          default("draft"), not null
#  title             :string           default(""), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  author_id         :bigint
#  category_id       :bigint
#
# Indexes
#
#  index_articles_on_author_id     (author_id)
#  index_articles_on_category_id   (category_id)
#  index_articles_on_published_at  (published_at)
#  index_articles_on_slug          (slug)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (category_id => categories.id)
#
