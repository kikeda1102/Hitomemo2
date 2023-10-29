import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/quiz.dart';

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
  late List<List<String>> generatedQuiz;

  // setStateを呼び出す関数
  void setStateOfParent() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // 問題を生成する
    generatedQuiz = quizManager.generateQuiz();
    // print('incorrectNames=${quiz.incorrectNames}');
    // print('generatedQuiz=$generatedQuiz');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'), // TODO: 何問目か表示
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

              // memos
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemBuilder: (context, index) => Card(
                    key: ValueKey(index),
                    child: ListTile(
                      title:
                          Text(widget.randomlySelectedProfiles[0].memos[index]),
                    ),
                  ),
                  itemCount: widget.randomlySelectedProfiles[0].memos.length,
                ),
              ),

              const SizedBox(height: 40),

              // 回答パネル
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnswerButtonWidget(
                      name: generatedQuiz[widget.quizPageIndex][0],
                      id: 0,
                      setStateOfParent: setStateOfParent),
                  AnswerButtonWidget(
                      name: generatedQuiz[widget.quizPageIndex][1],
                      id: 1,
                      setStateOfParent: setStateOfParent),
                  AnswerButtonWidget(
                      name: generatedQuiz[widget.quizPageIndex][2],
                      id: 2,
                      setStateOfParent: setStateOfParent),
                  AnswerButtonWidget(
                      name: generatedQuiz[widget.quizPageIndex][3],
                      id: 3,
                      setStateOfParent: setStateOfParent),
                ],
              ),

              const SizedBox(height: 40),

              CorrectAnswerWidget(
                service: widget.service,
                randomlySelectedProfiles: widget.randomlySelectedProfiles,
                quizPageIndex: widget.quizPageIndex,
                allProfiles: widget.allProfiles,
              ),
              // TODO: 採点、次のクイズへ遷移

              // const SizedBox(height: 200),
            ],
          ),
        ));
  }
}

// 一つの回答ボタン
class AnswerButtonWidget extends StatelessWidget {
  final String name; // 表示する名前
  final int id; // このボタンのid
  final Function() setStateOfParent;
  int index = 0;
  AnswerButtonWidget(
      {super.key,
      required this.name,
      required this.id,
      required this.setStateOfParent});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 次の文字を表示
        index++;
        setStateOfParent();
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(60, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(name[index]),
    );
  }
}

// 結果表示
class CorrectAnswerWidget extends StatelessWidget {
  final IsarService service;
  List<Profile> randomlySelectedProfiles;
  final int quizPageIndex; // いま何問目か
  final List<Profile> allProfiles;
  CorrectAnswerWidget(
      {super.key,
      required this.service,
      required this.randomlySelectedProfiles,
      required this.quizPageIndex,
      required this.allProfiles});

  @override
  Widget build(BuildContext context) {
    // TODO: ランダム選択を再実行

    return ElevatedButton(
      // TODO: onPressedを外から渡す設計にすれば省略できる
      // というか、括り出す必要がない
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => QuizPage(
                  service: service,
                  randomlySelectedProfiles: randomlySelectedProfiles,
                  quizPageIndex: quizPageIndex + 1,
                  allProfiles: allProfiles)),
        );
      },
      child: Text('Next'),
    );
  }
}
