require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Category, type: :model do
  context 'バリデーションの動作確認' do
    it 'name が有効な値の場合、有効になる' do
      category = build :category
      expect(category).to be_valid
    end

    it 'name が未定義の場合、無効になる' do
      category = build :category, name: nil
      category.valid?
      expect(category.errors.key?(:name)).to be true
    end

    it 'name が空文字の場合、無効になる' do
      category = build :category, name: ''
      category.valid?
      expect(category.errors.key?(:name)).to be true
    end

    it 'articles を持つ場合、children を登録できない' do
      parent = create :category, :with_articles
      category = build :category, parent: parent
      category.valid?
      expect(category.errors.key?(:base)).to be true
    end
  end

  context 'カウンターキャッシュの動作確認' do
    it '関連する Article が作成された際にカウンターが増える' do
      category = create :category
      expect do
        create_list :article, 3, category: category
      end.to change { category.articles_count }.by 3
    end
  end

  context '依存削除の動作確認' do
    it 'children を持つ Category インスタンスが削除された場合、children に属するレコードも削除される' do
      category = create :category, :with_children
      expect do
        category.destroy
      end.to change { Category.all.size }.by(-2)
    end

    it 'Category インスタンスが削除された場合、関連する Article インスタンスの外部キーが nil に設定される' do
      category = create :category, :with_articles
      article_id = category.articles.first.id
      category.destroy
      expect(Article.find(article_id).category_id).to be nil
    end
  end

  context '関数 parent? の動作確認' do
    it 'children を持つ場合 true を返す' do
      category = create :category, :with_children
      expect(category.parent?).to eq true
    end

    it 'children を持たない場合 false を返す' do
      category = create :category
      expect(category.parent?).to eq false
    end
  end

  context '関数 child? の動作確認' do
    it 'parent を持つ場合 true を返す' do
      category = create :category, :with_parent
      expect(category.child?).to eq true
    end

    it 'parent を持たない場合 false を返す' do
      category = create :category
      expect(category.child?).to eq false
    end
  end
end

# == Schema Information
#
# Table name: categories
#
#  id             :bigint           not null, primary key
#  articles_count :integer          default(0), not null
#  name           :string           default(""), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :bigint
#
# Indexes
#
#  index_categories_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => categories.id)
#
