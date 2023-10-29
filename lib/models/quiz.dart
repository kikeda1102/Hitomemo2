import 'dart:math' as math;

// Quizを管理するクラス
class QuizManager {
  String correctName; // 正解の名前
  List<String> incorrectNames; // 不正解の名前
  int step = 1; // いま何文字目か
  int numberOfIncorrectAnswers = 0; // 誤タップした数

  QuizManager({
    required this.correctName,
    required this.incorrectNames,
  });

  // TODO: 正解かどうかを判定するメソッド

  // 問題を生成するメソッド
  List<List<String>> generateQuiz() {
    // 例: quiz = [['山', '田', '鈴', 'J'], ['中', '田', 'o', '木'], ['花', 'h', '山', '太'], ['n', '夫', '郎', '子']]
    // incorrectNamesのうち、correctNameに含まれる文字列を含むものを除外する

    // 1. correctNameを1文字ずつ分割する
    List<String> correctNameSplit = correctName.split('');

    // 2. incorrectNamesを1文字ずつ分割する
    List<List<String>> incorrectNamesSplit = incorrectNames
        .map((String incorrectName) => incorrectName.split(''))
        .toList();

    // スペース除外
    incorrectNamesSplit = incorrectNamesSplit
        .map((List<String> incorrectNameSplit) => incorrectNameSplit
            .where((String incorrectNameSplit) => incorrectNameSplit != ' ')
            .toList())
        .toList();

    // 重複の除外
    incorrectNamesSplit = incorrectNamesSplit
        .map((List<String> incorrectNameSplit) =>
            incorrectNameSplit.toSet().toList())
        .toList();

    // 3. incorrectNamesSplitの各要素について、correctNameSplitに含まれる文字列を含むものを除外する
    // これにより、correctNameとの重複をなくす
    List<List<String>> incorrectNamesSplitFiltered = incorrectNamesSplit
        .map((List<String> incorrectNameSplit) => incorrectNameSplit
            .where((String incorrectNameSplit) =>
                !correctNameSplit.contains(incorrectNameSplit))
            .toList())
        .toList();

    // 空のリスト除外
    incorrectNamesSplitFiltered = incorrectNamesSplitFiltered
        .where((List<String> element) => element.isNotEmpty)
        .toList();

    // 中身を取り出してList<String>にする
    List<String> incorrectLetters = [
      for (List<String> element in incorrectNamesSplitFiltered) ...element
    ];

    // 4. 頭文字だけを取り出す
    List<String> incorrectFirstLetters = incorrectNamesSplitFiltered
        .map((List<String> element) => element[0])
        .toList();

    // quizの1要素め
    // incorrectFirstLettersをshuffleして最初の３つを取り出す
    incorrectFirstLetters.shuffle();
    List<String> incorrect3FirstLetters =
        incorrectFirstLetters.take(3).toList();
    incorrect3FirstLetters.shuffle();

    List<String> quizFirstLine = [
      correctNameSplit[0],
      ...incorrect3FirstLetters
    ];
    quizFirstLine.shuffle();

    // quizの2要素め以降
    // incorrectLettersをshuffleして最初の３つを取り出す
    incorrectLetters.shuffle();
    List<String> incorrect3Letters = incorrectLetters.take(3).toList();

    List<List<String>> quizFollowingLines = [];
    List<String> quizFollowingElement = [];
    for (int i = 1; i < correctNameSplit.length; i++) {
      quizFollowingElement = [correctNameSplit[i], ...incorrect3Letters];
      quizFollowingElement.shuffle();
      quizFollowingLines.add(quizFollowingElement);
    }

    // TODO: カスケード演算子の使い方を直す

    List<List<String>> quiz = [quizFirstLine, ...quizFollowingLines];

    // print(quiz);

    return quiz;
  }
}
