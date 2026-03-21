# GemShelf

個人用クラウドファイルアップローダー。Rails 8 + SQLite + Active Storage + Tailwind CSS v4 で構成。

## 必要な環境

- Docker
- Docker Compose

## 開発環境

### 起動

```bash
docker compose up
```

### 初回セットアップ（初めて起動するとき）

```bash
# データベースの作成・マイグレーション
docker compose run --rm web bin/rails db:migrate

# 初期ユーザーの作成（コンソールから）
docker compose run --rm web bin/rails console
```

コンソール内で実行:

```ruby
User.create!(email_address: "your@email.com", password: "yourpassword")
```

### アクセス

```
http://localhost:3000
```

### 停止

```bash
docker compose down
```

## 本番環境

### 事前準備

`SECRET_KEY_BASE` を生成する:

```bash
docker compose run --rm web bin/rails secret
```

### 起動

```bash
SECRET_KEY_BASE=<上で生成した値> docker compose -f compose.prod.yml up -d
```

### 初回セットアップ

```bash
SECRET_KEY_BASE=<値> docker compose -f compose.prod.yml run --rm web bin/rails db:migrate

SECRET_KEY_BASE=<値> docker compose -f compose.prod.yml run --rm web bin/rails console
```

コンソール内で実行:

```ruby
User.create!(email_address: "your@email.com", password: "yourpassword")
```

### 停止

```bash
docker compose -f compose.prod.yml down
```

## ファイル構成

| ファイル | 用途 |
|---|---|
| `compose.yml` | 開発用 Docker Compose |
| `compose.prod.yml` | 本番用 Docker Compose |
| `Dockerfile` | Docker イメージ定義 |

## 技術スタック

- Ruby on Rails 8.1
- SQLite（開発・本番共通）
- Active Storage（ファイル保存）
- Tailwind CSS v4
- Docker / Docker Compose
