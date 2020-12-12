require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Tag, type: :model do
  context 'バリデーションの動作確認' do
    it 'name が有効な値の場合、有効になる' do
      tag = build :tag
      expect(tag).to be_valid
    end

    it 'name が未定義の場合、無効になる' do
      tag = build :tag, name: nil
      tag.valid?
      expect(tag.errors.key?(:name)).to be true
    end

    it 'name が空文字の場合、無効になる' do
      tag = build :tag, name: ''
      tag.valid?
      expect(tag.errors.key?(:name)).to be true
    end

    it 'name がすでに存在する値の場合、無効になる' do
      posted_tag = create :tag
      tag = build :tag, name: posted_tag.name
      tag.valid?
      expect(tag.errors.key?(:name)).to be true
    end
  end

  context 'カウンターキャッシュの動作確認' do
    it '関連する Article が作成された際にカウンターが増える' do
      tag = create :tag
      expect do
        create_list :article, 3, tags: [tag]
      end.to change { tag.articles_count }.by 3
    end
  end

  context '依存削除の動作確認' do
    it 'Tag インスタンスが削除された場合、Article との中間テーブルのレコードも削除される' do
      tag = create :tag
      create_list :article, 3, tags: [tag]
      expect do
        tag.destroy
      end.to change { ArticleTagAttachment.all.size }.by(-3)
    end
  end

  context 'scope positive の動作確認' do
    it '記事が1つ以上紐付いているカテゴリのみを返す' do
      create_list :tag, 2
      create_list :article, 3, tags: [create(:tag)]
      create_list :article, 2, tags: [create(:tag)]
      scoped_tags = Tag.positive
      expect(scoped_tags.size).to eq 2
    end
  end
end

# == Schema Information
#
# Table name: tags
#
#  id             :bigint           not null, primary key
#  articles_count :integer          default(0), not null
#  name           :string           default(""), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
