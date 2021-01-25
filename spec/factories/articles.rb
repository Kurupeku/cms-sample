# frozen_string_literal: true

CONTENT_TEXT = <<~CONTENT
  <p>この文章はダミーテキストです。文字の大きさ・字間・行間などを確認するために入れています。この文章はダミーテキストです。文字の大きさ・字間・行間などを確認するために入れています。この文章はダミーテキストです。文字の大きさ・字間・行間などを確認するために入れています。</p>
  <h2>見出し 01</h2>
  <p>
    この文章はダミーテキストです。この文章はダミーテキストです。この文章はダミーテキストです。この文章はダミーテキストです。この文章はダミーテキストです。<br />
    この文章はダミーテキストです。この文章はダミーテキストです。この文章はダミーテキストです。この文章はダミーテキストです。この文章はダミーテキストです。<br />
    この文章はダミーテキストです。この文章はダミーテキストです。
  </p>
  <h2>見出し 02</h2>
  <p>この部分には○○文字ぐらいのテキストが入ります。</p>
  <p>この文章はダミーテキストです。文字の大きさ・字間・行間などを確認するために入れています。</p>
  <p>
    この文章はダミーテキストです。文字の大きさ・字間・行間などを確認するために入れています。この文章はダミーテキストです。文字の大きさ・字間・行間などを確認するために入れています。この文章はダミーテキストです。文字の大きさ・字間・行間などを確認するために入れています。<br />
    この文章はダミーテキストです。文字の大きさ・字間・行間などを確認するために入れています。この文章はダミーテキストです。文字の大きさ・字間・行間などを確認するために入れています。この文章はダミーテキストです。文字の大きさ・字間・行間などを確認するために入れています。<br />
    この文章はダミーテキストです。文字の大きさ・字間・行間などを確認するために入れています。
  </p>
  <h2>各パーツの表示例</h2>
  <p>
    この部分は<a href="#">インラインリンク</a>です。
  </p>
  <a class="button" href="#">button タグリンク</a>
  <h3>箇条書きリスト</h3>
  <ul>
    <li>リスト 01</li>
    <li>リスト 02</li>
    <li>リスト 03</li>
    <li>リスト 04</li>
    <li>リスト 05</li>
  </ul>
  <h3>番号付きリスト</h3>
  <ol>
    <li>リスト 01</li>
    <li>リスト 02</li>
    <li>リスト 03</li>
    <li>リスト 04</li>
    <li>リスト 05</li>
  </ol>
  <h3>テーブル</h3>
  <table>
    <thead>
      <tr>
        <th>Head 01</th>
        <th>Head 02</th>
        <th>Head 03</th>
        <th>Head 04</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Data 01-01</td>
        <td>Data 01-02</td>
        <td>Data 01-03</td>
        <td>Data 01-04</td>
      </tr>
      <tr>
        <td>Data 02-01</td>
        <td>Data 02-02</td>
        <td>Data 02-03</td>
        <td>Data 02-04</td>
      </tr>
      <tr>
        <td>Data 03-01</td>
        <td>Data 03-02</td>
        <td>Data 03-03</td>
        <td>Data 03-04</td>
      </tr>
    </tbody>
  </table>
  <h3>code要素</h3>
  <p>インラインコード表示<code>console.log("Hello world.")</code>のサンプルです。</p>
  <pre>
    <code>
      // pre要素のサンプルです。
      const hoge = "fuga";
      return new Piyo(hoge);
    </code>
  </pre>
CONTENT

FactoryBot.define do
  factory :article do
    author { create :user }
    category { nil }
    sequence(:title) { |n| "Article #{n}" }
    content { CONTENT_TEXT }
    published_at { Time.current }
    status { 0 }
    article_type { 0 }
    sequence(:slug) { |n| "slug-#{n}" }

    trait :with_category do
      category { create :category }
    end

    trait :with_comments do
      after :create do |article|
        random = Random.rand 0..10
        create_list :comment, random, article: article
      end
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
