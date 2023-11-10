import 'dart:math' as math;

// Quizを管理するクラス
class QuizManager {
  String correctName; // 正解の名前
  List<int> correctNameIndexes = []; // 正解の名前の位置
  List<String> incorrectNames; // 不正解の名前
  int quizStep = 0; // いま何文字目か
  int numberOfIncorrectAnswers = 0; // 誤タップした数
  bool currentResult = false; // いまの回答の正誤

  QuizManager({
    required this.correctName,
    required this.incorrectNames,
  });

  // 問題を生成するメソッド
  List<List<String>> generateQuiz() {
    // correctLettersを生成する
    List<String> correctLetters =
        generateCorrectLetters(); // 例: ['A', 'l', 'i', 'c', 'e']

    // correctNameIndexを生成する
    correctNameIndexes = generateCorrectNameIndex(); // 例: [3, 1, 0, 2, 2]

    // incorrectNames, incorrectNameInitialsを生成する
    List<String> incorrectLetters =
        generateIncorrectLetters(); // ['B', 'o', 'b', 'C', 'a', 'r', 'o', 'l',....]

    List<String> incorrectInitials =
        generateIncorrectInitials(); // ['B', 'C',....]

    // quizの1行めを生成する
    List<String> quizFirstLine =
        generateQuizFirstLine(correctLetters, incorrectInitials);

    // quizの2要素め以降
    List<List<String>> quizFollowingLines = [];
    // correctLettersの2文字目以降を、incorrect3Lettersに挿入する
    for (int i = 1; i < correctLetters.length; i++) {
      // incorrect3Lettersを生成
      incorrectLetters.shuffle();
      List<String> incorrect3Letters = incorrectLetters.take(3).toList();
      // correctNameIndexesの位置に、correctLetters[i]を挿入する
      incorrect3Letters.insert(correctNameIndexes[i], correctLetters[i]);

      // quizFollowingLinesに追加
      quizFollowingLines.add(incorrect3Letters);
    }

    // quizFirstLineとquizFollowingLinesを結合し、最終的に返すquizを作る
    List<List<String>> quiz = [quizFirstLine, ...quizFollowingLines];

    // print('correctNameIndexes=$correctNameIndexes');
    // print('quiz=$quiz');
    return quiz;
  }

  // correctLettersを生成するメソッド
  List<String> generateCorrectLetters() {
    // correctNameを1文字ずつ分割し、空白を除外
    List<String> correctLetters =
        correctName.split('').where((char) => char != ' ').toList();
    return correctLetters;
  }

  // correctNameIndexを生成するメソッド
  List<int> generateCorrectNameIndex() {
    // correctNameの各文字が、quizのどの位置に置かれるかを示す
    List<int> correctNameIndexes = List.generate(
        correctName.length, (index) => math.Random().nextInt(4)); // 0~3の乱数を生成
    return correctNameIndexes;
  }

  // quizFirstLineを生成するメソッド
  List<String> generateQuizFirstLine(
      List<String> correctLetters, List<String> incorrectLetters) {
    // quizの1要素め
    // incorrectLettersから、頭文字だけを取り出す
    List<String> incorrectInitials = generateIncorrectInitials();
    // incorrectInitialsをshuffleして最初の３つを取り出す
    incorrectInitials.shuffle();
    List<String> incorrect3Initials = incorrectInitials.take(3).toList();
    incorrect3Initials.shuffle();
    // correctNameIndexesの位置に、correctLetters[0]を挿入する
    incorrect3Initials.insert(correctNameIndexes[0], correctLetters[0]);
    List<String> quizFirstLine = incorrect3Initials;
    return quizFirstLine;
  }

  // incorrectLettersを生成するメソッド
  List<String> generateIncorrectLetters() {
    // incorrectNamesを1文字ずつ分割する
    List<String> incorrectLetters = incorrectNames.join('').split('');
    // スペース文字を除外
    incorrectLetters =
        incorrectLetters.where((String char) => char != ' ').toList();
    // 全体の中で複数回登場する文字の除外 ユニークにする
    incorrectLetters = incorrectLetters.toSet().toList();

    // correctLettersに含まれる文字列を含むものを除外、correctNameとの文字の重複をなくす
    // correctNameを1文字ずつ分割する
    List<String> correctLetters = correctName.split('');
    incorrectLetters = incorrectLetters
        .where((String char) => !correctLetters.contains(char))
        .toList();
    return incorrectLetters;
  }

  // incorrectInitialsを生成するメソッド
  List<String> generateIncorrectInitials() {
    // incorrectNamesの頭文字を取り出す
    List<String> incorrectInitials =
        incorrectNames.map((String name) => name[0]).toList();
    // correctNameの頭文字を取り出す
    List<String> correctInitials = correctName.split('').map((char) {
      if (char == ' ') {
        return '';
      } else {
        return char;
      }
    }).toList();
    // correctInitialsに含まれる文字列を含むものを除外、correctNameとの文字の重複をなくす
    incorrectInitials = incorrectInitials
        .where((String char) => !correctInitials.contains(char))
        .toList();
    return incorrectInitials;
  }
}
