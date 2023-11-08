import 'package:hito_memo_2/models/profile.dart';

// Quizの採点結果を管理するクラス
class QuizResultManager {
  List<Profile> correctProfiles = []; // 正解のProfileのリスト
  List<int> numbersOfIncorrectTaps = []; // 誤タップした回数のリスト
  QuizResultManager({
    required this.correctProfiles,
    required this.numbersOfIncorrectTaps,
  });
}
