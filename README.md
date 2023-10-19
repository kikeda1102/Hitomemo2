# hito_memo_2

初対面の人や友達など、周りの人のプロフィールを記録しておくアプリ

## 検討事項
- アプリ名
  「人の単語帳」であることを押し出したい
  profile flashcardとか？

## 構成

- pages
  - home_page.dart: 開始時画面
- models
  - profile.dart: Profileクラスを定義
- services
  - isar_service.dart: IsarDBへのCRUD操作を行う関数を定義
- components
  - add_tag_widget.dart: personalTag追加機能を切り出したもの

### 進捗記録

- 2023/10/19:
  - クイズ画面を作った
    - QuizGatePageで問題数選択
    - QuizPageでクイズ表示
    - QuizResultPageで結果表示 (未実装)
  中身の機能の実装が未完成
  - スライダーの挙動がカクつく問題が発生中
    →FutureBuilderのfutureで関数を読んでいるためsetState()で再度読み込まれていたのが原因
    lateを使ってstate変数としてとってくることで解決
  - クイズ機能の仕様検討
    - 正解の名前を渡す
    - それに応じてハズレの名前を選ぶ
    - 選択された文字列の情報を保持する

  AnswerPanelWidget:
  - メンバ変数リスト
    - 正解文字列 String correctName
    - ハズレの文字列群 List<String> incorrectNames
    - step数 (いま何文字目) int step
    - 誤答数 (減点数) int numOfIncorrectTap
  - メソッドリスト
    - 正誤判定 judge
    - 正解+誤答*3を生成する関数 generateQuiz

  - 来週までに、クイズのメソッドの実装をしてくる


- 2023/10/12:
  - detailsのmemosをreorderableにした
  - UI改善: Material3 / Card表示にした / BottomNavigationBar
  - TODO: details画面での更新
    - 更新ボタンはなしにし、onSubmittedでDB更新する仕様にする
  - TODO: BottomNavigationBarの遷移
    - 各ボタンの状態を保持したまま切り替えしたい → navigator_scope パッケージ
  - TODO: クイズ機能
    - 1日1回通知が飛んできて、クイズを促してくれる ←Sazaさんの神アイデア
    - Quizクラスを定義
      - 問題、解答、...
    - クイズの生成とクイズ画面の描画(実行)を切り分ける
      - StreamBuilderをやめて、buildで書ける
  - TODO: 削除したデータの一定期間保持

- 2023/10/4: 
  - memoを長文ではなく、箇条書き風に再設計したい: 細かい点を除けばdone
  - クイズ機能をつけたい: todo
  - Navigator.popでvalidationできる？: WillPopScopeがあるが、今回の場合はTextFormFieldのonChangedでvalidateすればよい

  - TODO:
    - 文字数制限など細かい点を詰める
    - UI詰める 実機テスト
    - クイズ機能 できるとこまで


- 2023/9/20: HitoMemoではcopilotに頼りすぎ、自力で書き直したくなったので、hito_memo_2リポジトリを作ってリファクタ開始
  - buildできて、listenで更新できるとこまで行きたかった: まだ
  - isar_service.dartの設計についてちゃんと考え直したい
  - 次回: 画面とlistenまで実装

- 以前の問題:
  - add_tag_widgetにおけるonPressedの関数を切り出す再設計: done
  - profile_detail_pageのlistenによる更新: まだ