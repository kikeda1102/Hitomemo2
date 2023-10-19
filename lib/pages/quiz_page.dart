import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
// import 'package:isar/isar.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/quiz.dart';

// クイズのページ
class QuizPage extends StatefulWidget {
  final IsarService service;
  final List<Profile> randomlySelectedProfiles;
  final int numberOfQuestions; // いま何問目か
  final List<Profile> allProfiles;
  const QuizPage(
      {super.key,
      required this.service,
      required this.randomlySelectedProfiles,
      required this.numberOfQuestions,
      required this.allProfiles});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // Quizクラス
  late final Quiz quiz = Quiz(
    correctName: widget.randomlySelectedProfiles[widget.numberOfQuestions].name,
    incorrectNames: widget.allProfiles.map((e) => e.name).toList(),
  );
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

              const Text('Who is this?'),

              const SizedBox(height: 40),

              // 回答パネル
              AnswerPanelWidget(),

              const SizedBox(height: 40),

              CorrectAnswerWidget(
                service: widget.service,
                randomlySelectedProfiles: widget.randomlySelectedProfiles,
                numberOfQuestions: widget.numberOfQuestions,
                allProfiles: widget.allProfiles,
              ),
              // TODO: 採点
              // TODO: 次のクイズへ遷移

              // const SizedBox(height: 200),
            ],
          ),
        ));
  }
}

// 回答パネル
class AnswerPanelWidget extends StatelessWidget {
  const AnswerPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnswerButtonWidget(name: '池田けんや'),
        AnswerButtonWidget(name: '山田たろう'),
        AnswerButtonWidget(name: '佐々木はなこ'),
        AnswerButtonWidget(name: '田中じろう'),
      ],
    );
  }
}

// 一つの回答ボタン
class AnswerButtonWidget extends StatelessWidget {
  final String name; // 表示する名前

  const AnswerButtonWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(60, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(name),
    );
  }
}

// 結果表示
class CorrectAnswerWidget extends StatelessWidget {
  final IsarService service;
  List<Profile> randomlySelectedProfiles;
  final int numberOfQuestions; // いま何問目か
  final List<Profile> allProfiles;
  CorrectAnswerWidget(
      {super.key,
      required this.service,
      required this.randomlySelectedProfiles,
      required this.numberOfQuestions,
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
                  numberOfQuestions: numberOfQuestions + 1,
                  allProfiles: allProfiles)),
        );
      },
      child: Text('Next'),
    );
  }
}
