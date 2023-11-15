import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/models/quiz_result_manager.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/quiz_manager.dart';
import 'package:hito_memo_2/pages/quiz_result_page.dart';

// クイズのページ
class QuizPage extends StatefulWidget {
  final IsarService service;
  final List<Profile> correctProfiles;
  final int quizPageIndex; // いま何問目か
  final List<Profile> allProfiles;
  final QuizResultManager quizResultManager;
  const QuizPage(
      {super.key,
      required this.service,
      required this.correctProfiles,
      required this.quizPageIndex,
      required this.allProfiles,
      required this.quizResultManager});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // QuizManagerクラスのインスタンスを生成
  late final QuizManager quizManager = QuizManager(
    // 正解の名前
    correctName: widget.correctProfiles[widget.quizPageIndex].name,
    incorrectNames:
        widget.allProfiles.map((e) => e.name).toList(), // 全部のprofileを渡している
  );
  late List<List<String>> generatedQuiz; // initStateで生成されるクイズ
  bool quizCompleted = false; // クイズが終了したかどうか

  // setStateを呼び出す関数
  void setStateOfParent() {
    setState(() {});
  }

  // quizCompletedをtrueにする関数
  void updateQuizCompleted() {
    quizCompleted = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // クイズを生成する
    generatedQuiz = quizManager.generateQuiz();
    // print('incorrectNames=${quiz.incorrectNames}');
    // print('generatedQuiz=$generatedQuiz');
  }

  @override
  Widget build(BuildContext context) {
    // 正解/不正解を表示するテキスト
    Icon resultIcon = const Icon(Icons.done);
    if (quizCompleted == true) {
      resultIcon = const Icon(Icons.celebration, size: 40, color: Colors.green);
    } else if (quizManager.currentResult == true) {
      resultIcon =
          const Icon(Icons.done, size: 40, color: Colors.green); // 正解のアイコンを表示
    } else if (quizManager.currentResult == false) {
      resultIcon =
          const Icon(Icons.close, size: 40, color: Colors.red); // 不正解のアイコンを表示
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.quizPageIndex + 1} / ${widget.correctProfiles.length}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Who is this?',
                  style: TextStyle(
                    fontSize: 20,
                  )),

              const SizedBox(height: 20),

              // memosを表示
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemBuilder: (context, index) => Card(
                    key: ValueKey(index),
                    child: ListTile(
                      title: Text(widget
                          .correctProfiles[widget.quizPageIndex].memos[index]),
                    ),
                  ),
                  itemCount:
                      widget.correctProfiles[widget.quizPageIndex].memos.length,
                ),
              ),

              const SizedBox(height: 40),

              // 回答パネル
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnswerButtonWidget(
                      quizManager: quizManager,
                      quizResultManager: widget.quizResultManager,
                      generatedQuiz: generatedQuiz,
                      buttonId: 0,
                      quizCompleted: quizCompleted,
                      setStateOfParent: setStateOfParent,
                      updateQuizCompleted: updateQuizCompleted),
                  AnswerButtonWidget(
                      quizManager: quizManager,
                      quizResultManager: widget.quizResultManager,
                      generatedQuiz: generatedQuiz,
                      buttonId: 1,
                      quizCompleted: quizCompleted,
                      setStateOfParent: setStateOfParent,
                      updateQuizCompleted: updateQuizCompleted),
                  AnswerButtonWidget(
                      quizManager: quizManager,
                      quizResultManager: widget.quizResultManager,
                      generatedQuiz: generatedQuiz,
                      buttonId: 2,
                      quizCompleted: quizCompleted,
                      setStateOfParent: setStateOfParent,
                      updateQuizCompleted: updateQuizCompleted),
                  AnswerButtonWidget(
                      quizManager: quizManager,
                      quizResultManager: widget.quizResultManager,
                      generatedQuiz: generatedQuiz,
                      buttonId: 3,
                      quizCompleted: quizCompleted,
                      setStateOfParent: setStateOfParent,
                      updateQuizCompleted: updateQuizCompleted),
                ],
              ),

              const SizedBox(height: 40),

              // 正解/不正解を表示
              AnimatedOpacity(
                // 1度以上タップされたら、アイコンを表示
                opacity: quizManager.quizStep > 0 ||
                        quizManager.numberOfIncorrectAnswers > 0
                    ? 1.0
                    : 0.0,
                duration: const Duration(milliseconds: 0),
                child: resultIcon,
              ),

              const SizedBox(height: 40),

              // const SizedBox(height: 200),
            ],
          ),
        ),
      ),
      bottomNavigationBar: // 次へボタン
          Container(
        padding: const EdgeInsets.all(30),
        child: Visibility(
          visible: quizCompleted,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: NextQuizButton(
            service: widget.service,
            correctProfiles: widget.correctProfiles,
            quizPageIndex: widget.quizPageIndex,
            allProfiles: widget.allProfiles,
            quizCompleted: quizCompleted,
            quizManager: quizManager,
            quizResultManager: widget.quizResultManager,
          ),
        ),
      ),
    );
  }
}

// 一つの回答ボタン
class AnswerButtonWidget extends StatelessWidget {
  final QuizManager quizManager;
  final QuizResultManager quizResultManager;
  final List<List<String>> generatedQuiz;
  final int buttonId; // このボタンのid
  final bool quizCompleted;
  final Function() setStateOfParent;
  final Function() updateQuizCompleted;
  const AnswerButtonWidget({
    super.key,
    required this.quizManager,
    required this.quizResultManager,
    required this.generatedQuiz,
    required this.buttonId,
    required this.quizCompleted,
    required this.setStateOfParent,
    required this.updateQuizCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 最後の文字で正解が選択されたら、scoreを計算して次に遷移
        if (quizManager.quizStep >=
                quizManager.correctName
                        .split('')
                        .where((char) => char != ' ')
                        .length -
                    1 &&
            buttonId == quizManager.correctNameIndexes[quizManager.quizStep]) {
          // 最後の文字で正解が選択された場合
          updateQuizCompleted(); // quizCompletedをtrueにする
          quizManager.currentResult = true;

          // 誤タップ数をquizResultManagerに追加
          quizResultManager.numbersOfIncorrectTaps
              .add(quizManager.numberOfIncorrectAnswers);
        } else if (buttonId ==
            quizManager.correctNameIndexes[quizManager.quizStep]) {
          // 正解が選択された場合
          quizManager.quizStep++;
          quizManager.currentResult = true;
        } else {
          // 間違いが選択された場合
          quizManager.numberOfIncorrectAnswers++;
          quizManager.currentResult = false;
        }
        setStateOfParent();
        // print('quizManager.quizStep=${quizManager.quizStep}');
        // print(
        //     'quizManager.numberOfIncorrectAnswers=${quizManager.numberOfIncorrectAnswers}');
        // print('quizCompleted=$quizCompleted');
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(60, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(generatedQuiz[quizManager.quizStep][buttonId]),
    );
  }
}

// 次へボタン
class NextQuizButton extends StatelessWidget {
  final IsarService service;
  final List<Profile> correctProfiles;
  final int quizPageIndex; // いま何問目か
  final List<Profile> allProfiles;
  final bool quizCompleted;
  final QuizManager quizManager;
  final QuizResultManager quizResultManager;
  const NextQuizButton(
      {super.key,
      required this.service,
      required this.correctProfiles,
      required this.quizPageIndex,
      required this.allProfiles,
      required this.quizCompleted,
      required this.quizManager,
      required this.quizResultManager});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 最後の問題であれば、Resultページへ遷移
        if (quizPageIndex == correctProfiles.length - 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => QuizResultPage(
                      service: service,
                      quizResultManager: quizResultManager,
                    )),
          );
        } else {
          // 次の問題へ
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => QuizPage(
                    service: service,
                    correctProfiles: correctProfiles,
                    quizPageIndex: quizPageIndex + 1,
                    allProfiles: allProfiles,
                    quizResultManager: quizResultManager)),
          );
        }
      },
      child: const Text('Next'),
    );
  }
}
