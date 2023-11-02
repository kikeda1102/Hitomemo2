import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/quiz_manager.dart';
import 'package:hito_memo_2/pages/quiz_result_page.dart';

// クイズのページ
class QuizPage extends StatefulWidget {
  final IsarService service;
  final List<Profile> randomlySelectedProfiles;
  final int quizPageIndex; // いま何問目か
  final List<Profile> allProfiles;
  const QuizPage(
      {super.key,
      required this.service,
      required this.randomlySelectedProfiles,
      required this.quizPageIndex,
      required this.allProfiles});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // QuizManagerクラスのインスタンスを生成
  late final QuizManager quizManager = QuizManager(
    // 正解の名前
    correctName: widget.randomlySelectedProfiles[widget.quizPageIndex].name,
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
    return Scaffold(
        appBar: AppBar(
          title: Text(
              '${widget.quizPageIndex + 1} / ${widget.randomlySelectedProfiles.length}'), // TODO: 何問目か表示
        ),
        body: Padding(
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
                          .randomlySelectedProfiles[widget.quizPageIndex]
                          .memos[index]),
                    ),
                  ),
                  itemCount: widget
                      .randomlySelectedProfiles[widget.quizPageIndex]
                      .memos
                      .length,
                ),
              ),

              const SizedBox(height: 40),

              // 回答パネル
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnswerButtonWidget(
                      quizManager: quizManager,
                      generatedQuiz: generatedQuiz,
                      id: 0,
                      quizCompleted: quizCompleted,
                      setStateOfParent: setStateOfParent,
                      updateQuizCompleted: updateQuizCompleted),
                  AnswerButtonWidget(
                      quizManager: quizManager,
                      generatedQuiz: generatedQuiz,
                      id: 1,
                      quizCompleted: quizCompleted,
                      setStateOfParent: setStateOfParent,
                      updateQuizCompleted: updateQuizCompleted),
                  AnswerButtonWidget(
                      quizManager: quizManager,
                      generatedQuiz: generatedQuiz,
                      id: 2,
                      quizCompleted: quizCompleted,
                      setStateOfParent: setStateOfParent,
                      updateQuizCompleted: updateQuizCompleted),
                  AnswerButtonWidget(
                      quizManager: quizManager,
                      generatedQuiz: generatedQuiz,
                      id: 3,
                      quizCompleted: quizCompleted,
                      setStateOfParent: setStateOfParent,
                      updateQuizCompleted: updateQuizCompleted),
                ],
              ),

              const SizedBox(height: 40),

              // 次へボタン
              Visibility(
                visible: quizCompleted,
                child: NextQuizButton(
                  service: widget.service,
                  randomlySelectedProfiles: widget.randomlySelectedProfiles,
                  quizPageIndex: widget.quizPageIndex,
                  allProfiles: widget.allProfiles,
                  quizCompleted: quizCompleted,
                ),
              ),

              // const SizedBox(height: 200),
            ],
          ),
        ));
  }
}

// 一つの回答ボタン
class AnswerButtonWidget extends StatelessWidget {
  final QuizManager quizManager;
  final List<List<String>> generatedQuiz;
  final int id; // このボタンのid
  final bool quizCompleted;
  final Function() setStateOfParent;
  final Function() updateQuizCompleted;
  const AnswerButtonWidget(
      {super.key,
      required this.quizManager,
      required this.generatedQuiz,
      required this.id,
      required this.quizCompleted,
      required this.setStateOfParent,
      required this.updateQuizCompleted});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 最後の文字で正解が選択されたら、結果表示に遷移
        if (quizManager.quizStep >=
                quizManager.correctName
                        .split('')
                        .where((char) => char != ' ')
                        .length -
                    1 &&
            id == quizManager.correctNameIndexes[quizManager.quizStep]) {
          updateQuizCompleted(); // quizCompletedをtrueにする
        } else if (id == quizManager.correctNameIndexes[quizManager.quizStep]) {
          quizManager.quizStep++;
          // TODO: 正解のエフェクトを出す
        } else {
          quizManager.numberOfIncorrectAnswers++;
          // TODO: 間違っているエフェクトを出す
        }
        setStateOfParent();
        print('quizManager.quizStep=${quizManager.quizStep}');
        print(
            'quizManager.numberOfIncorrectAnswers=${quizManager.numberOfIncorrectAnswers}');
        print('quizCompleted=$quizCompleted');
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(60, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(generatedQuiz[quizManager.quizStep][id]),
    );
  }
}

// 次へボタン
class NextQuizButton extends StatelessWidget {
  final IsarService service;
  final List<Profile> randomlySelectedProfiles;
  final int quizPageIndex; // いま何問目か
  final List<Profile> allProfiles;
  final bool quizCompleted;
  const NextQuizButton(
      {super.key,
      required this.service,
      required this.randomlySelectedProfiles,
      required this.quizPageIndex,
      required this.allProfiles,
      required this.quizCompleted});

  @override
  Widget build(BuildContext context) {
    if (quizCompleted == true) {
      return ElevatedButton(
        onPressed: () {
          if (quizPageIndex == randomlySelectedProfiles.length - 1) {
            // Resultページへ遷移
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => QuizResultPage(
                        service: service,
                      )),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => QuizPage(
                      service: service,
                      randomlySelectedProfiles: randomlySelectedProfiles,
                      quizPageIndex: quizPageIndex + 1,
                      allProfiles: allProfiles)),
            );
          }
        },
        child: const Text('Next'),
      );
    }
    return const SizedBox.shrink();
  }
}
