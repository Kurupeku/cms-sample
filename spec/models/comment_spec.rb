require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Comment, type: :model do
  context 'バリデーションの動作確認' do
    it 'article, content が有効な値の場合、有効になる' do
      comment = build :comment
      expect(comment).to be_valid
    end

    it 'content が未定義の場合、無効になる' do
      comment = build :comment, article: nil
      comment.valid?
      expect(comment.errors.key?(:article)).to be true
    end

    it 'content が未定義の場合、無効になる' do
      comment = build :comment, content: nil
      comment.valid?
      expect(comment.errors.key?(:content)).to be true
    end

    it 'content が空文字の場合、無効になる' do
      comment = build :comment, content: ''
      comment.valid?
      expect(comment.errors.key?(:content)).to be true
    end
  end

  context '関数 set_unknown_author_name の動作確認' do
    it 'author_name が未定義の場合、「匿名ユーザー」として処理される' do
      comment = build :comment, author_name: nil
      comment.valid?
      expect(comment.author_name).to eq '匿名ユーザー'
    end

    it 'author_name が空文字の場合、「匿名ユーザー」として処理される' do
      comment = build :comment, author_name: ''
      comment.valid?
      expect(comment.author_name).to eq '匿名ユーザー'
    end
  end

  context '関数 check_current_user の動作確認' do
    it '引数に User インスタンスを与えたの場合、関連付けが行われる' do
      user = create :user
      comment = build :comment
      comment.check_current_user user
      expect(comment.user_id).to eq user.id
    end

    it '引数に nil を与えたの場合、関連付けは行われない' do
      comment = build :comment
      comment.check_current_user nil
      expect(comment.user_id).to eq nil
    end
  end
end

# == Schema Information
#
# Table name: comments
#
#  id           :bigint           not null, primary key
#  author_agent :string           default(""), not null
#  author_ip    :string           default(""), not null
#  author_name  :string           default(""), not null
#  author_url   :string           default(""), not null
#  content      :text             default(""), not null
#  status       :integer          default("published"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  article_id   :bigint           not null
#  user_id      :bigint
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
