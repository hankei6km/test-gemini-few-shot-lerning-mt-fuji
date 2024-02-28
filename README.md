# test-gemini-few-shot-lerning-mt-fuji

Gemini で少数ショット学習を使い定点カメラの画像を判定してみる実験のリポジトリ。

## ファイル一覧

### 共通ファイル

- `images`: [ライブカメラ富士山ビュー](https://www.pref.shizuoka.jp/fujisanview/1044916.html)からダウンロードした画像
  - 場所: 御殿場
  - 期間: 2023-03-01 から 2024-02-26(中途半端な期間ですが、27 日に記事を書き始めたためでとく意味はありません)
  - 対象時刻: 午前 9 時に撮影された写真

### 少数ショット学習用ファイル

- `samples`: 少数ショット学習の例としてプロンプトに含める画像
- `gemini.sh`: 少数ショット学習を用いて富士山の写真を判定するスクリプト、Markdown テーブルを出力する。
- `batch.sh`: `gemini.sh` を月別に実行するスクリプト
- `res`: `batch.sh` を実行した結果を月別に保存しているディレクトリ

### 少数ショット学習無し用ファイル

- `gemini-none.sh`: 少数ショット学習を使わずに富士山の写真を判定するスクリプト、Markdown テーブルを出力する。
- `batch-none.sh`: `gemini-none.sh` を月別に実行するスクリプト
- `res-none`: `batch.sh` を実行した結果を月別に保存しているディレクトリ

## 画像の判定

`images` に保存されている各ファイルに対して、富士山が見えるかどうかを判定する。

## 実行方法

環境変数 `API_KEY` へ Gemini の API キーを設定。

以下のように `gemini.sh` を実行すると結果が Markdown として保存される。

```sh
./gemini.sh 2023/06/01 30 | tee res/202306.md
```

実行結果のサンプル:

| Date       | Image                                                                                                           | Answer             | Page                                                                   |
| ---------- | --------------------------------------------------------------------------------------------------------------- | ------------------ | ---------------------------------------------------------------------- |
| 2024-02-01 | ![](https://raw.githubusercontent.com/hankei6km/test-gemini-few-shot-lerning-mt-fuji/main/images/20240201.jpeg) | 富士山は見えない   | https://www.pref.shizuoka.jp/fujisanview/365.html?date=20240201gotenba |
| 2024-02-02 | ![](https://raw.githubusercontent.com/hankei6km/test-gemini-few-shot-lerning-mt-fuji/main/images/20240202.jpeg) | 富士山は見えない   | https://www.pref.shizuoka.jp/fujisanview/365.html?date=20240202gotenba |
| 2024-02-03 | ![](https://raw.githubusercontent.com/hankei6km/test-gemini-few-shot-lerning-mt-fuji/main/images/20240203.jpeg) | 富士山は見えます。 | https://www.pref.shizuoka.jp/fujisanview/365.html?date=20240203gotenba |

`batch.sh` を実行すると月別に `gemini.sh` を実行し、結果を `res` ディレクトリに保存する。

表の `Answer` に `null` がセットされた場合は、API 側の内部エラーなどが発生した場合です。

## クレジット

- 写真の出典: 静岡県([ライブカメラ富士山ビューについて｜静岡県公式ホームページ](https://www.pref.shizuoka.jp/fujisanview/1044916.html))
- クリエイティブ・コモンズ 表示-非営利 4.0 国際: https://creativecommons.org/licenses/by-nc/4.0/deed.ja
