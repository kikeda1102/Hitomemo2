import 'package:isar/isar.dart';

part 'settings.g.dart';

// Settingsクラス: 設定を格納
@Collection()
class Settings {
  Id id; // Isarのid
  String language; // 言語
  bool presentQuizScore; // クイズの正答率を表示するか
  bool presentCreatedAt; // 登録日時を表示するか

  // コンストラクタ
  Settings({
    this.id = Isar.autoIncrement,
    required this.language,
    required this.presentQuizScore,
    required this.presentCreatedAt,
  });

  // copyWithメソッドを定義
  Settings copyWith({
    String? newLanguage,
    bool? newPresentQuizScore,
    bool? newPresentCreatedAt,
  }) {
    return Settings(
      language: newLanguage ?? language,
      presentQuizScore: newPresentQuizScore ?? presentQuizScore,
      presentCreatedAt: newPresentCreatedAt ?? presentCreatedAt,
    );
  }
}
