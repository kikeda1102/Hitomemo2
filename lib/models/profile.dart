import 'package:isar/isar.dart';

part 'profile.g.dart';

// Profileクラス: 登録者の情報を格納
@Collection()
class Profile {
  Id id; // Isarのid
  final int order; // ReorderableListViewで並び順を管理するための変数
  final DateTime created;
  final DateTime? updated;
  final String name;
  final List<byte>? imageBytes; // 画像
  final List<String> memos; //箇条書きのメモ
  final int? numberOfIncorrectTaps; // quizで誤タップされた回数

  // コンストラクタ
  Profile({
    this.id = Isar.autoIncrement,
    this.order = -1, // 一番上に表示するため、初期値は-1
    this.updated,
    required this.name,
    this.imageBytes,
    required this.memos,
    this.numberOfIncorrectTaps,
  }) : created = DateTime.now();

  // copyWithメソッドを定義
  Profile copyWith({
    int? id,
    int? order,
    // DateTime? created,
    DateTime? updated,
    String? name,
    List<int>? imageBytes,
    List<String>? memos,
    int? numberOfIncorrectTaps,
  }) {
    return Profile(
      id: id ?? this.id,
      order: order ?? this.order,
      // created: created ?? this.created,
      updated: updated ?? this.updated,
      name: name ?? this.name,
      imageBytes: imageBytes ?? this.imageBytes,
      memos: memos ?? this.memos,
      numberOfIncorrectTaps:
          numberOfIncorrectTaps ?? this.numberOfIncorrectTaps,
    );
  }

  // 正答率を計算するメソッド %単位
  int? calculateCorrectRate() {
    if (numberOfIncorrectTaps == null) {
      return null;
    } else {
      int correctRate = 0;
      // スペースを除外
      String correctName = name.replaceAll(' ', '');
      correctRate = 100 *
          (correctName.length - numberOfIncorrectTaps!) ~/
          correctName.length;
      // 0未満にならないようにする
      if (correctRate < 0) {
        correctRate = 0;
      }
      return correctRate;
    }
  }

  // ランクを計算するメソッド
  String correctRateRank() {
    int? correctRate = calculateCorrectRate();
    if (correctRate == null) {
      return 'null';
    } else if (correctRate == 100) {
      return 'perfect';
    } else if (correctRate >= 70) {
      return 'good';
    } else {
      return 'bad';
    }
  }
}
