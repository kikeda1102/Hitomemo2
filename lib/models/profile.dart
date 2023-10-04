import 'package:isar/isar.dart';

part 'profile.g.dart';

// Profileクラス: 登録者の情報を格納
@Collection()
class Profile {
  Id id; // Isarのid
  int order; // ReorderableListViewで並び順を管理するための変数
  DateTime created;
  DateTime? updated;
  String name;
  List<byte>? imageBytes; // 画像
  List<String> memos; //箇条書きのメモ

  // コンストラクタ
  Profile({
    this.id = Isar.autoIncrement,
    this.order = -1, // 一番上に表示するため、初期値は-1
    this.updated,
    required this.name,
    this.imageBytes,
    required this.memos,
  }) : created = DateTime.now();

  // copyWithメソッドを定義
  Profile copyWith({
    int? newId,
    int? newOrder,
    // DateTime? created,
    DateTime? newUpdated,
    String? newName,
    List<int>? newImageBytes,
    List<String>? newMemos,
  }) {
    return Profile(
      id: newId ?? id,
      order: newOrder ?? order,
      // created: created ?? this.created,
      updated: newUpdated ?? updated,
      name: newName ?? name,
      imageBytes: newImageBytes ?? imageBytes,
      memos: newMemos ?? memos,
    );
  }
}
