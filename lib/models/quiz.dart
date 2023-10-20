// Quizクラス
class Quiz {
  String correctName; // 正解の名前
  List<String> incorrectNames; // 不正解の名前
  int step = 1; // いま何文字目か
  int numberOfIncorrectAnswers = 0; // 誤タップした数

  Quiz({
    required this.correctName,
    required this.incorrectNames,
  });

  // TODO: メソッドの定義
  // Statefulの中で書いた方がよさそう
  // 正解かどうかを判定するメソッド
  // 問題を生成するメソッド
}
