# Welcome to rails-docker
Rails6 + webpacker + mysql を docker-composeで構築
## Dockerコンテナのビルド

```
# 通常のビルド
docker-compose build
# キャッシュ利用無しでビルド
docker-compose build --no-cache
# コンテナをボリュームごと削除して再ビルド
docker-compose down -v
docker-compose build --no-cache
```
## Dockerコンテナ起動

```
# rails + webpacker + mysql 起動
docker-compose up
# バックグラウンド起動
docker-compose up -d
```
## データベースの設定

```
# mysqlコンテナログイン
docker-compose exec db bash

mysql -u root -pexample

# dbuserを作成
create user 'dbuser'@'%' identified by 'dbpass';
grant all on *.* to 'dbuser'@'%';
```

## 最初からアプリを作り直す
rails-appフォルダ内のファイルを全て削除してから以下のコマンドを実行

```
# railsコンテナログイン
docker-compose exec web bash -l

# バンドル初期設定
bundle init
# gem 'rails' のコメントを解除
vi Gemfile
# rails をインストール
bundle install --path vendor/bundle
# railsアプリの作成とgemインストール
bundle exec rails new . --database=mysql --skip-test 
# webpackインストール(yarnのバージョンが古いとwebpackがインストールされないことがある)
bundle exec rails webpacker:install
```

rails-app/config/database.ymlを修正

```
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: dbuser
  password: dbpass
  host: db
```

```
# データベースを再作成
bundle exec rails db:migrate:reset
```

## rbenvのコマンド一覧

```
# rbenvのバージョンを表示
$ rbenv -v

# 現在使用中のRubyのバージョンを表示
$ rbenv version

# インストール済みのRubyのバージョンを全て表示
$ rbenv versions

# デフォルトで利用するバージョンを指定
$ rbenv global 3.0.0

# 個別のアプリで使用したいバージョンを指定
$ rbenv local 3.0.0

# インストール可能なRubyのバージョン一覧を表示
$ rbenv install -l

# 指定したRubyのバージョンをインストール
$ rbenv install 3.0.0
```