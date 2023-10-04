# hito_memo_2

初対面の人や友達など、周りの人のプロフィールを記録しておくアプリ

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