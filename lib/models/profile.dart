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
  List<byte>? imageBytes;
  List<String> personalTags;
  String memo; // TODO: 長文メモではなく、箇条書き風に再設計

  // コンストラクタ
  Profile({
    this.id = Isar.autoIncrement,
    this.order = -1, // 一番上に表示するため、初期値は-1
    this.updated,
    required this.name,
    this.imageBytes,
    required this.personalTags,
    required this.memo,
  }) : created = DateTime.now();

  // copyWithメソッドを定義
  Profile copyWith({
    int? id,
    int? order,
    // DateTime? created,
    DateTime? updated,
    String? name,
    List<int>? imageBytes,
    List<String>? personalTags,
    String? memo,
  }) {
    return Profile(
      id: id ?? this.id,
      order: order ?? this.order,
      // created: created ?? this.created,
      updated: updated ?? this.updated,
      name: name ?? this.name,
      imageBytes: imageBytes ?? this.imageBytes,
      personalTags: personalTags ?? this.personalTags,
      memo: memo ?? this.memo,
    );
  }
}
