# hito_memo_2

初対面の人や友達など、周りの人のプロフィールを記録しておくアプリ

## 問題点

memos の onReorder をしたとき rangeError が出る

### 考えられる原因 ← ほんとにこれ原因？？

edit_profile_widget において、
newProfile は final の外部引数として受け取っているのに、
newProfile.memos = ...
と更新してしまっている

## 解決策

現状 newProfile は profile_detail_page で 更新可能な late として定義し,それを stateless である edit_profile_widget に渡している。
そこで、

- Profile クラスのメンバ変数を全て immutable にする
- newProfile の変更をするメソッド copyWith() を用意し、それを引き渡す。

### 修正

上記原因が本当に今の問題の原因かは不明だが、現状がよくない実装なのは確かなので、
上記解決策に従って修正する

## メモ

onReorder で register の時だけ再描画されない問題
Key に index のみ与えていたのが問題だった
memos も与える事で解決

## 検討事項

- アプリ名
  「人の単語帳」であることを押し出したい
  profile flashcard とか？

## 構成

- pages
  - home_page.dart: 開始時画面
- models
  - profile.dart: Profile クラスを定義
- services
  - isar_service.dart: IsarDB への CRUD 操作を行う関数を定義
- components
  - add_tag_widget.dart: personalTag 追加機能を切り出したもの

### 進捗記録

- 2023/10/19:

  - クイズ画面を作った
    - QuizGatePage で問題数選択
    - QuizPage でクイズ表示
    - QuizResultPage で結果表示 (未実装)
      中身の機能の実装が未完成
  - スライダーの挙動がカクつく問題が発生中
    →FutureBuilder の future で関数を読んでいるため setState()で再度読み込まれていたのが原因
    late を使って state 変数としてとってくることで解決
  - クイズ機能の仕様検討
    - 正解の名前を渡す
    - それに応じてハズレの名前を選ぶ
    - 選択された文字列の情報を保持する

  AnswerPanelWidget:

  - メンバ変数リスト
    - 正解文字列 String correctName
    - ハズレの文字列群 List<String> incorrectNames
    - step 数 (いま何文字目) int step
    - 誤答数 (減点数) int numOfIncorrectTap
  - メソッドリスト

    - 正誤判定 judge
    - 正解+誤答\*3 を生成する関数 generateQuiz

  - 来週までに、クイズのメソッドの実装をしてくる

- 2023/10/12:

  - details の memos を reorderable にした
  - UI 改善: Material3 / Card 表示にした / BottomNavigationBar
  - TODO: details 画面での更新
    - 更新ボタンはなしにし、onSubmitted で DB 更新する仕様にする
  - TODO: BottomNavigationBar の遷移
    - 各ボタンの状態を保持したまま切り替えしたい → navigator_scope パッケージ
  - TODO: クイズ機能
    - 1 日 1 回通知が飛んできて、クイズを促してくれる ←Saza さんの神アイデア
    - Quiz クラスを定義
      - 問題、解答、...
    - クイズの生成とクイズ画面の描画(実行)を切り分ける
      - StreamBuilder をやめて、build で書ける
  - TODO: 削除したデータの一定期間保持

- 2023/10/4:

  - memo を長文ではなく、箇条書き風に再設計したい: 細かい点を除けば done
  - クイズ機能をつけたい: todo
  - Navigator.pop で validation できる？: WillPopScope があるが、今回の場合は TextFormField の onChanged で validate すればよい

  - TODO:
    - 文字数制限など細かい点を詰める
    - UI 詰める 実機テスト
    - クイズ機能 できるとこまで

- 2023/9/20: HitoMemo では copilot に頼りすぎ、自力で書き直したくなったので、hito_memo_2 リポジトリを作ってリファクタ開始

  - build できて、listen で更新できるとこまで行きたかった: まだ
  - isar_service.dart の設計についてちゃんと考え直したい
  - 次回: 画面と listen まで実装

- 以前の問題:
  - add_tag_widget における onPressed の関数を切り出す再設計: done
  - profile_detail_page の listen による更新: まだ
