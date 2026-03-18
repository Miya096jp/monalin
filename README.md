# README

Monalin is an ai powered self-expression console

## セットアップ
### 前提条件: 以下がインストール済みであること
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### 手順

1. リポジトリをクローン
```bash
git clone https://github.com/Miya096jp/monalin.git
```

2. プロジェクトオーナーから受け取ったmaster keyを設定
```bash
echo "マスターキー" > config/master.key`
```

3. コンテナのビルドと起動
```bash
docker compose build
docker compose up -d
```

4. データベース・seedのセットアップ

```bash
docker compose exec web bin/rails db:setup
```

5. アプリにアクセスしOmniAuthでユーザー登録
http://localhost:3000/login

6. 登録したユーザーとseedを紐づける
```bash
# docker compose exec web bin/rails rails c
user = User.find_by(email: "メールアドレス")
Session.update_all(user_id: user.id)
```


## テストの実行

```bash
# 全テスト
docker compose exec web bundle exec rspec
```

## 本番ドメイン
```
https://monalin.com
```


* Ruby version
* System dependencies
* Configuration
* Database creation
* Database initialization
* How to run the test suite
* Services (job queues, cache servers, search engines, etc.)
* Deployment instructions
...
