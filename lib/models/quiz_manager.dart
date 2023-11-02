import 'dart:math' as math;

// Quizを管理するクラス
class QuizManager {
  String correctName; // 正解の名前
  List<int> correctNameIndexes = []; // 正解の名前の位置
  List<String> incorrectNames; // 不正解の名前
  int quizStep = 0; // いま何文字目か
  int numberOfIncorrectAnswers = 0; // 誤タップした数

  QuizManager({
    required this.correctName,
    required this.incorrectNames,
  });

  // 問題を生成するメソッド
  List<List<String>> generateQuiz() {
    // correctNameSplitを生成する
    List<String> correctNameSplit =
        generateCorrectNameSplit(); // 例: ['A', 'l', 'i', 'c', 'e']

    // correctNameIndexを生成する
    correctNameIndexes = generateCorrectNameIndex(); // 例: [3, 1, 0, 2, 2]

    // incorrectNamesSplitFilteredを生成する
    List<List<String>> incorrectNamesSplitFiltered =
        generateIncorrectNamesSplitFiltered(); // 例: [['B', 'o', 'b'], ['C', 'a', 'r', 'o', 'l']]

    // quizの1行めを生成する
    List<String> quizFirstLine =
        generateQuizFirstLine(correctNameSplit, incorrectNamesSplitFiltered);

    // quizの2要素め以降

    List<List<String>> quizFollowingLines = [];
    // correctNameSplitの2文字目以降を、incorrect3Lettersに挿入する
    for (int i = 1; i < correctNameSplit.length; i++) {
      // incorrect3Lettersを生成
      List<String> incorrect3Letters =
          generateIncorrect3Letters(incorrectNamesSplitFiltered);
      // correctNameIndexesの位置に、correctNameSplit[i]を挿入する
      incorrect3Letters.insert(correctNameIndexes[i], correctNameSplit[i]);

      // quizFollowingLinesに追加
      quizFollowingLines.add(incorrect3Letters);
    }

    // quizFirstLineとquizFollowingLinesを結合し、最終的に返すquizを作る
    List<List<String>> quiz = [quizFirstLine, ...quizFollowingLines];

    print('correctNameIndexes=$correctNameIndexes');
    print('quiz=$quiz');
    return quiz;
  }

  // correctNameSplitを生成するメソッド
  List<String> generateCorrectNameSplit() {
    // correctNameを1文字ずつ分割し、空白を除外
    List<String> correctNameSplit =
        correctName.split('').where((char) => char != ' ').toList();
    return correctNameSplit;
  }

  // correctNameIndexを生成するメソッド
  List<int> generateCorrectNameIndex() {
    // correctNameの各文字が、quizのどの位置に置かれるかを示す
    List<int> correctNameIndexes = List.generate(
        correctName.length, (index) => math.Random().nextInt(4)); // 0~3の乱数を生成
    return correctNameIndexes;
  }

  // quizFirstLineを生成するメソッド
  List<String> generateQuizFirstLine(List<String> correctNameSplit,
      List<List<String>> incorrectNamesSplitFiltered) {
    // quizの1要素め
    // incorrectNamesSplitFilteredから、頭文字だけを取り出す
    List<String> incorrectFirstLetters = incorrectNamesSplitFiltered
        .map((List<String> element) => element[0])
        .toList();
    // incorrectFirstLettersをshuffleして最初の３つを取り出す
    incorrectFirstLetters.shuffle();
    List<String> incorrect3FirstLetters =
        incorrectFirstLetters.take(3).toList();
    incorrect3FirstLetters.shuffle();
    // correctNameIndexesの位置に、correctNameSplit[0]を挿入する
    incorrect3FirstLetters.insert(correctNameIndexes[0], correctNameSplit[0]);
    List<String> quizFirstLine = incorrect3FirstLetters;
    return quizFirstLine;
  }

  // incorrectNamesSplitFilteredを生成するメソッド
  List<List<String>> generateIncorrectNamesSplitFiltered() {
    // 1. correctNameを1文字ずつ分割する
    List<String> correctNameSplit = correctName.split('');

    // 2. incorrectNamesを1文字ずつ分割する
    List<List<String>> incorrectNamesSplit = incorrectNames
        .map((String incorrectName) => incorrectName.split(''))
        .toList();

    // スペース文字を除外
    incorrectNamesSplit = incorrectNamesSplit
        .map((List<String> incorrectNameSplit) => incorrectNameSplit
            .where((String incorrectNameSplit) => incorrectNameSplit != ' ')
            .toList())
        .toList();

    // 複数回登場する文字の除外
    incorrectNamesSplit = incorrectNamesSplit
        .map((List<String> incorrectNameSplit) =>
            incorrectNameSplit.toSet().toList())
        .toList();

    // correctNameSplitに含まれる文字列を含むものを除外、correctNameとの文字の重複をなくす
    List<List<String>> incorrectNamesSplitFiltered = incorrectNamesSplit
        .map((List<String> incorrectNameSplit) => incorrectNameSplit
            .where((String incorrectNameSplit) =>
                !correctNameSplit.contains(incorrectNameSplit))
            .toList())
        .toList();

    // 空のリスト除外
    // incorrectNamesにはcorrectNameが含まれているので、空のリストができている
    incorrectNamesSplitFiltered = incorrectNamesSplitFiltered
        .where((List<String> element) => element.isNotEmpty)
        .toList();

    return incorrectNamesSplitFiltered;
  }

  // incorrect3Lettersを生成するメソッド
  List<String> generateIncorrect3Letters(
      List<List<String>> incorrectNamesSplitFiltered) {
    // incorrectNamesSplitFilteredの中身を展開
    // List<List<String>> から List<String> にする
    List<String> incorrectLetters = [
      for (List<String> element in incorrectNamesSplitFiltered) ...element
    ];
    // 文字の重複をなくす
    incorrectLetters = incorrectLetters.toSet().toList();
    // incorrectLettersをshuffleして最初の３つを取り出す
    incorrectLetters.shuffle();
    List<String> incorrect3Letters = incorrectLetters.take(3).toList();
    return incorrect3Letters;
  }
}
