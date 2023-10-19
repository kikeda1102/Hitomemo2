import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
// import 'package:isar/isar.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/quiz.dart';
import 'package:hito_memo_2/pages/quiz_page.dart';

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
  int _startValue = 1;
  int _endValue = 0;

  void _changeSlider(double e) => setState(() {
        _value = e.toInt();
      });
  // void _startSlider(double e) => setState(() {
  //       _startValue = e.toInt();
  //     });
  // void _endSlider(double e) => setState(() {
  //       _endValue = e.toInt();
  //     });
  late final numberOfProfiles = widget.service.getNumberOfProfiles();

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
              future: numberOfProfiles,
              builder: (context, snapshot) {
                int? numberOfProfiles = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || numberOfProfiles == null) {
                  return const CircularProgressIndicator();
                } else if (numberOfProfiles <= 3) {
                  // profilesが4件未満の時の処理
                  return const Text(
                    'Register at least 4 people to start quiz.',
                  );
                } else {
                  _endValue = numberOfProfiles; // スライダーの最大値を設定
                  // _value = numberOfProfiles; // スライダーの初期値を設定
                  return Column(
                    children: [
                      const Text('Number of questions'),
                      // TODO: スライダーのカクつきを改善
                      Slider(
                        value: _value.toDouble(),
                        min: _startValue.toDouble(),
                        max: _endValue.toDouble(),
                        divisions: (_endValue - 1).toInt(),
                        label: _value.toInt().toString(),
                        onChanged: _changeSlider,
                        // onChangeStart: _startSlider,
                        // onChangeEnd: _endSlider,
                      ),

                      // Startボタン
                      ElevatedButton(
                          child: const Text('Start'),
                          onPressed: () async {
                            // データのランダム取得
                            List<Profile> randomlySelectedProfiles =
                                await widget.service
                                    .getProfilesRomdomly(_value.toInt());

                            if (!context.mounted) {
                              return; // asyncを使ったbuild対策. このページが表示されていない時は何もしない
                            }

                            // クイズページへ遷移
                            final List<Profile> allProfiles =
                                await widget.service.getAllProfiles();

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                        service: widget.service,
                                        randomlySelectedProfiles:
                                            randomlySelectedProfiles,
                                        numberOfQuestions: 0,
                                        allProfiles: allProfiles,
                                      )),
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
