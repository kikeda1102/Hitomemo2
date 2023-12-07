import 'package:flutter/material.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/quiz_result_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 結果を表示するページ
class QuizResultPage extends StatefulWidget {
  final IsarService service;
  final QuizResultManager quizResultManager;
  const QuizResultPage(
      {super.key, required this.service, required this.quizResultManager});

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  @override
  void initState() {
    super.initState();
    // 結果をDBに保存
    for (int i = 0; i < widget.quizResultManager.correctProfiles.length; i++) {
      widget.quizResultManager.correctProfiles[i] =
          widget.quizResultManager.correctProfiles[i].copyWith(
        newNumberOfIncorrectTaps:
            widget.quizResultManager.numbersOfIncorrectTaps[i],
      );
      widget.service.putProfile(widget.quizResultManager.correctProfiles[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 自動で生成される戻るボタンを無効化
        leading: MyBackButton(service: widget.service),
        title: const Text('Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.quizResultManager.correctProfiles.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                          widget.quizResultManager.correctProfiles[index].name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget
                                .quizResultManager.correctProfiles[index].memos
                                .join('     '), // memosの要素を改行で結合して表示
                          ),
                        ],
                      ),
                      // 正答率
                      trailing: Text(
                        // nullなら何も表示しない
                        widget.quizResultManager.correctProfiles[index]
                                    .numberOfIncorrectTaps ==
                                null
                            ? ''
                            : '${widget.quizResultManager.correctProfiles[index].calculateCorrectRate()}',
                        // correctRateRankに従って色を変える
                        style: widget.quizResultManager.correctProfiles[index]
                                    .correctRateRank() ==
                                'perfect'
                            ? const TextStyle(color: Colors.green, fontSize: 20)
                            : widget.quizResultManager.correctProfiles[index]
                                        .correctRateRank() ==
                                    'good'
                                ? const TextStyle(
                                    color: Colors.orange, fontSize: 20)
                                : const TextStyle(
                                    color: Colors.red, fontSize: 20),
                      ),
                    ),
                  );
                },
              ),
            ),
            // 戻るボタン
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.backToQuizTop),
              onPressed: () {
                // quiz gate pageに遷移
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class MyBackButton extends StatelessWidget {
  final IsarService service;
  const MyBackButton({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Icon(Icons.arrow_back),
      onPressed: () {
        // quiz gate pageに遷移
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }
}
