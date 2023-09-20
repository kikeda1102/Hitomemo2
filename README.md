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

- 以前の問題:
  - add_tag_widgetにおけるonPressedの関数を切り出す再設計: done
  - profile_detail_pageのlistenによる更新: まだ
- 2023/9/20: HitoMemoではcopilotに頼りすぎ、自力で書き直したくなったので、hito_memo_2リポジトリを作ってリファクタ開始
  - buildできて、listenで更新できるとこまで行きたかった: まだ
  - isar_service.dartの設計についてちゃんと考え直したい
  - vscodeのsnippetの設定について
  - 次回: 画面とlistenまで実装
