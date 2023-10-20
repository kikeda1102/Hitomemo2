import 'dart:math' as math;

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
  List<List<String>> generateQuiz(
      String correctName, List<String> incorrectNames) {
    // 正解の名前をランダムに配置する場所を決める
    final correctNaameLength = correctName.length;
    List<String> correctNameList = correctName.split('');
    // correctNameListの各文字に対し、0~3の乱数を割り当てる
    List<int> correctNamePosition = [
      for (int i = 0; i < correctNaameLength; i++) math.Random().nextInt(4)
    ];
    // correctNameとincorrectNamesから問題を生成
    List<List<String>> quiz = [
      for (int i = 0; i < 4; i++)
        if (i == correctNamePosition[i])
          [correctNameList[i], 'correct']
        else
          [incorrectNames[i], 'incorrect']
    ];

    return quiz;
  }
}
