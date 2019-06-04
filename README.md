# slack_ramen_bot

## 使用技術
- Ruby
- GAS
- Slash Command
- GCP
- Selenium

## 概要
1. Slackから「/ramen」入力
2. Slash Command処理が走る
3. GASにてPOSTを受け取る
4. スプレッドシート(DB)からデータ取得する
5. GASにて取得したデータを元に返すJsonパラメータを組む
6. SlackにJsonデータを返す
7. Slackにオススメのラーメン店出力

-データについて-
`Ramen_bot.rb` にて、*gem clockwork* を用いてスクレイピングを定期実行
スクレイピングの頻度は１ヶ月に１回
そのため、１ヶ月に１回ラーメンのデータは書き換わる

