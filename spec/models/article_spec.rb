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
    let(:article) { create :article }

    it '関連する Comment が作成された際にカウンターが増える' do
      expect do
        create :comment, article: article
      end.to change { article.comments_count }.by 1
    end
  end

  context '更新日を基準に公開済みの前後の記事を取得する関数の動作確認' do
    let(:articles) { create_list :article, 3, status: 1 }
    let(:base_article) { articles.second }

    it '前の記事を取得する' do
      expect(base_article.previous).to eq articles.first
    end

    it '次の記事を取得する' do
      expect(base_article.next).to eq articles.last
    end
  end

  context '依存削除の動作確認' do
    let(:article) { create :article }

    it 'Article インスタンスが削除された場合、関連する Comment も削除される' do
      create_list :comment, 3, article: article
      expect do
        article.destroy
      end.to change { Comment.all.size }.by(-3)
    end

    it 'Article インスタンスが削除された場合、Tag との中間テーブルのレコードも削除される' do
      create_list :tag, 3, articles: [article]
      expect do
        article.destroy
      end.to change { ArticleTagAttachment.all.size }.by(-3)
    end
  end

  context 'set_opening_sentence の動作確認' do
    let(:content_string) { 'sample content text.' * 10 }
    let(:article) { create :article, content: content_string }
    let(:reg) { %r{</?[^>]+?>}.freeze }

    it 'content が登録された際に、先頭40byte文の文章が opening_sentence に登録される' do
      article = create :article, content: content_string
      expect(article.opening_sentence).to eq content_string.gsub(reg, '').truncate(40)
    end
  end

  context 'set_published_at の動作確認' do
    let(:article) { create :article, status: :published }

    it 'status が published になった際に、published_at へ現在時刻が登録される' do
      expect(article.published_at).to be_truthy
    end

    it 'status がすでに published だった場合、published_at は更新されない' do
      before_time = article.published_at
      article.published!
      expect(before_time).to eq article.published_at
    end
  end

  context 'set_default_position の動作確認' do
    let(:article_a) { build :article, article_type: :static }
    let(:article_b) { build :article, article_type: :static }

    it 'article_type が static だった場合、position に同カラム最大値 + 1 がセットされる' do
      article_a.save
      expect(article_a.position).to eq 1

      article_b.save
      expect(article_b.position).to eq 2
    end
  end

  context 'remove_published_at の動作確認' do
    let(:article) { create :article, status: :draft }

    it 'status が draft になった際に、published_at が削除される' do
      expect(article.published_at).to be_falsey
    end

    it 'status がすでに draft だった場合、published_at は更新されない' do
      before_time = article.published_at
      article.draft!
      expect(before_time).to eq article.published_at
    end
  end

  context 'move_to の動作確認' do
    let(:statics) { create_list :article, 3, article_type: :static }

    it 'インスタンスの position を引数の値に更新し、その値以上の record の position を繰り上げて保存する' do
      statics.first.move_to 2
      expect(statics.second.reload.position).to eq 1

      statics.third.move_to 1
      expect(statics.second.reload.position).to eq 2
    end
  end

  context 'comments_choices の動作確認' do
    let(:article) { create :article, status: :draft }

    it '関連付けられた Comment の一覧を number 昇順にソートし、[select の表示名, select の value] 形式で取得する' do
      create_list :comment, 10, article: article
      last_comment = article.comments.last
      expect(article.comments_choices.last).to eq ["No.#{last_comment.number}", last_comment.id]
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
#  content           :text             default(""), not null
#  impressions_count :integer          default(0), not null
#  opening_sentence  :string           default("")
#  position          :integer
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
