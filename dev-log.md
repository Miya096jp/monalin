

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
- xxx

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
