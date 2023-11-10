import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/pages/quiz_page.dart';
import 'package:hito_memo_2/models/quiz_result_manager.dart';

// クイズの開始ページ

class QuizGatePage extends StatefulWidget {
  final IsarService service;
  const QuizGatePage({super.key, required this.service});

  @override
  State<QuizGatePage> createState() => _QuizGatePageState();
}

class _QuizGatePageState extends State<QuizGatePage> {
  // スライダーの値
  int _value = 1;
  final int _minValue = 1;
  int _maxValue = 0;
  // スライダーの値を変更する関数
  void _changeSlider(double e) => setState(() {
        _value = e.toInt();
      });
  // 有効な全profilesの数を取得
  late final numberOfValidProfiles = widget.service.getNumberOfValidProfiles();
  // quizResultManagerを生成
  late final QuizResultManager quizResultManager;

  @override
  void initState() {
    super.initState();
    Future(() async {
      _value = await numberOfValidProfiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('Quiz',
                style: TextStyle(
                  fontSize: 30,
                )),
          ),

          const SizedBox(height: 40),

          // 問題数を選択するスライダー
          FutureBuilder(
              future: numberOfValidProfiles,
              builder: (context, snapshot) {
                int? numberOfValidProfiles = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || numberOfValidProfiles == null) {
                  return const CircularProgressIndicator();
                } else if (numberOfValidProfiles <= 3) {
                  // TODO: numberOfValidProfilesが4件未満の時の処理
                  return const Text(
                    'Register at least 4 valid profiles to start quiz.',
                    textAlign: TextAlign.center,
                  );
                } else {
                  _maxValue = numberOfValidProfiles; // スライダーの最大値を設定

                  return Column(
                    children: [
                      const Text('Number of questions',
                          style: TextStyle(fontSize: 16)),

                      const SizedBox(height: 10),

                      Slider(
                        value: _value.toDouble(),
                        min: _minValue.toDouble(),
                        max: _maxValue.toDouble(),
                        divisions: (_maxValue - 1).toInt(),
                        label: _value.toInt().toString(),
                        onChanged: _changeSlider,
                      ),

                      const SizedBox(height: 40),

                      // Startボタン
                      ElevatedButton(
                          child: const Text('Start'),
                          onPressed: () async {
                            // データのランダム取得
                            List<Profile> correctProfiles = await widget.service
                                .getProfilesRomdomly(_value.toInt());

                            final List<Profile> allProfiles =
                                await widget.service.getAllProfiles();

                            // クイズページへ遷移
                            if (!context.mounted) {
                              return; // asyncを使ったbuild対策. このページが表示されていない時は何もしない
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                // QuizPageへ遷移
                                builder: (context) => QuizPage(
                                  service: widget.service,
                                  correctProfiles: correctProfiles,
                                  quizPageIndex: 0,
                                  allProfiles: allProfiles,
                                  quizResultManager: QuizResultManager(
                                    correctProfiles: correctProfiles,
                                    numbersOfIncorrectTaps: <int>[],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  );
                }
              }),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
