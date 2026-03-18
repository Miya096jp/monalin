# 2026-03-16

[OmniAuth認証の実装 #42](https://github.com/Miya096jp/monalin/issues/42)

Feature: ログイン/登録ページ作成・current_userを設定(7050b1)
Feature: sessions/registrationsコントローラーを作成(066e17)
Feature: 認証周りのroutesを作成(e38430)
Feature: Omniauthのsecrets保存と初期設定(02c57d)
Feature: social_accountモデル作成, db制約, Userモデルとの関連付け(9f6333)

---

# 2026-03-15

[Issue: ユーザーモデルの作成#41](https://github.com/Miya096jp/monalin/issues/41)

## Feature: Rspecの初期設定とUser model specを作成(71fa60)
- Userモデルのvalidation, enumのテストを実装

---

# 2026-03-14

[Issue: ユーザーモデルの作成#41](https://github.com/Miya096jp/monalin/issues/41)

## Feature: Userモデル作成とvalidation追加(8f30a6)
- rails consoleでUserリソースのCRUDとdb制約、validation、enumの動作確認


---

# 2026-03-08

## Fix: rubyを安定版の3.4.3に変更(605152)
- デフォルトで最新の4.0.1になっていたので、念の為安定版に変更

## Fix: KamalのaccessoryにpostgresSQLを指定し設定を追加(af6bc3)
- postgreSQLコンテナ用の設定を追加
- database.ymlにhost:追加
- config.deploy.ymlにaccesories他を追加
- .kamal/secretsにPOSTGRES_PASSWORDを追加
- 手動デプロイに成功

## Chore: .kamal/secretsを.gitignoreに追加(31993e)
- デフォルトで追加されていなかったので手動で追加

## Config: Kamalの手動デプロイ設定(c12ee7)
- config/deploy.ymlの編集

## Chore: dotenv gemをインストール(396fdb)
- config/deploy.ymlの注釈を参照してインストールしたが、.kamal/secretsを使用したため未使用。
- 今後使わなかったら削除する

---

# 2026-03-07

## [Feature] rootにlpを作成し"Hello world!"を表示 (d755e6)


# 2026-03-05

## [CONFIG] ciを通すため空のtest/sytemディレクトリと空のdb/schema.rbを作成(c564be)
- test/system/.keepを定義しGitHubに空ディレクトリを追跡させる
- CI test実行前のdb:prepareに対応するため空のschema.rbを作成した


## [CINFIG] Gemfile.lockを同期し、CI用のx86_64-linuxプラットフォームを追加(00f5b4)
- 昨日build中にGemfileのタイポが原因でやり直した際に、GemfileとGemfile.lockの中身がズレたらしい
- AppleシリコンとGithub ActionsのubuntuではOS実行環境が異なる

---

# 2026-03-04

## [CONFIG] Docker開発環境構築(9b2d5eb)
- Dockerfile.dev、compose.yml作成しコンテナ起動成功。localhost:3000でRails表示を確認
- デプロイはKamal2で行う

---
##############
# テンプレート
##############

# year-month-day

## [BUGFIX] title (#commit-hash)

### 問題
- xxx

### 期待動作
- xxx

### 原因
- xxx

### 解決策
- xxx

### 影響範囲
- xxx

### 補足 
- xxx

### 技術詳細

---

## [CHORE] title (#commit-hash)

種別: リファクタ / 依存関係更新 / 設定変更 / ドキュメント / CI/CD


### 目的
- xxx

### 変更前
 xxx

### 変更後
- xxx

### 確認事項
- 動作確認した内容

### 補足
- xxx

CHOREでよくある作業
- 依存関係の更新（gem, npm）
- リファクタリング
- 設定ファイルの変更
- 不要コードの削除
- CI/CDの調整
- ドキュメント更新

---

## [FEATURE] title (#commit-hash)

### 概要
- 何を追加・変更したか

### 目的
- なぜ必要だったか

### 補足
- 関連情報など
---
```

# ガイドライン

## 1. エントリ

- `[FEATURE]` - 新機能開発
- `[CHORE]` - 新機能を伴わない変更
- `[BUGFIX]` - バグ修正
- `[REFACTOR]` - リファクタリング
- `[CONFIG]` - 設定変更
- `[DOCS]` - ドキュメント更新
- `[DEPLOY]` - デプロイ関連
- `[SECURITY]` - セキュリティ対応
- `[ENHANCE]` - 既存機能の改善、拡張
