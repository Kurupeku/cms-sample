# CMS SAMPLE APP

このプロジェクトは Wordpress などと同様の CMS として作成したプロジェクトです。

## DEMO

作成中

## 動作環境

- Debian: 10
- Ruby: 2.7.2
- Node.js: 15.7.0

## 開発環境

開発環境には Docker を使用しています。

1. [Docker for Desktop](https://www.docker.com/products/docker-desktop) 使用している OS に合わせてインストール
2. データベース用のボリュームを作成（初回のみ）

```bash
docker volume create --name cms-sample-db
```

3. このプロジェクトの Root で Docker Image の作成とコンテナの起動を行う

```bash
docker-compose up -d --build
```

4. `データベースの初期化と migrate を行う（初回のみ）

```bash
docker-compose run rails bundle exec rails db:create
docker-compose run rails bundle exec rails db:migrate
```

5. サーバーを起動する

```bash
docker-compose run rails bundle exec foreman start -b 0.0.0.0
```

## 使用している主な Gem / ライブラリ

### Ruby (on Rails)

- [PG](https://github.com/ged/ruby-pg)
- [Dotenv-rails](https://github.com/bkeepers/dotenv)
- [Slim-rails](https://github.com/slim-template/slim)
- [Ransack](https://github.com/activerecord-hackery/ransack)
- [Kaminari](https://github.com/kaminari/kaminari)
- [Fast Jsonapi](https://github.com/Netflix/fast_jsonapi)
- [I18n](https://github.com/svenfuchs/rails-i18n)
- [Devise](https://github.com/heartcombo/devise)
- [Devise-auth-token](https://github.com/lynndylanhurley/devise_token_auth)
- [Impressionist](https://github.com/charlotte-ruby/impressionist)
- [Gretel](https://github.com/lassebunk/gretel)
- [Factroy Bot Rails](https://github.com/thoughtbot/factory_bot)
- [Rubocop](https://github.com/rubocop-hq/rubocop)
- [Foreman](https://github.com/ddollar/foreman)
- [Rspec-rails](https://github.com/rspec/rspec-rails)
- [Webdrivers](https://github.com/titusfortner/webdrivers)

### JavaScript (via NPM)

- [TypeScript](https://www.typescriptlang.org/)
- [React](https://ja.reactjs.org/)
- [Create React App](https://ja.reactjs.org/docs/create-a-new-react-app)
- [React Rooter](https://reactrouter.com/)
- [I18next](https://www.i18next.com/)
- [UIKit](https://getuikit.com/)
- [Material UI](https://material-ui.com/)
- [Axios](https://github.com/axios/axios)

## 実装している機能

### 一般公開ページ

Ruby on Rails のテンプレートエンジンを使用して出力しています。

- 記事一覧
- 記事詳細
- コメント投稿
- 問い合わせ機能
- カテゴリ別記事一覧
- タグ別記事一覧
- 各一覧ページで 投稿日 / 更新日 / 閲覧数 で記事をソート
- 一覧表示件数変更
- 最近人気の記事を表示
- SNS シェア

### 管理画面

Ruby on Rails のデータベースを REST API としてデータを配信し、フロントエンドは React で実装しています。

- ユーザー認証
- ユーザー管理[^1]
- 記事管理[^1]
- 固定ページ管理[^1]
- 画像管理[^1]
- カテゴリ管理[^1]
- タグ管理[^1]
- 問い合わせ管理[^1]
- 設定の変更[^1]

[^1]: 作成途中

## License

This software is released under the MIT License, see LICENSE.
