import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
// import 'package:isar/isar.dart';
import 'package:hito_memo_2/services/isar_service.dart';

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
  int _startValue = 0;
  int _endValue = 0;

  void _changeSlider(double e) => setState(() {
        _value = e.toInt();
      });
  void _startSlider(int e) => setState(() {
        _startValue = e;
      });
  void _endSlider(int e) => setState(() {
        _endValue = e;
      });

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

          const Text('Number of questions'),

          // TODO: スライダーの実装

          // 問題数を選択するスライダー
          FutureBuilder(
              future: widget.service.getNumberOfProfiles(),
              builder: (context, snapshot) {
                int? numberOfProfiles = snapshot.data;
                // TODO: 0件の時の処理
                if (snapshot.hasData && numberOfProfiles != null) {
                  _endValue = numberOfProfiles;
                  return Slider(
                    value: _value.toDouble(),
                    min: _startValue.toDouble(),
                    max: _endValue.toDouble(),
                    divisions: _endValue.toInt(),
                    label: _value.toInt().toString(),
                    onChanged: _changeSlider,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),

          const SizedBox(height: 60),

          // Startボタン
          ElevatedButton(
              child: const Text('Start'),
              onPressed: () async {
                // データのランダム取得
                List<Profile> randomlySelectedProfiles =
                    await widget.service.getProfilesRomdomly(_value.toInt());

                if (!context.mounted) {
                  return; // asyncを使ったbuild対策. このページが表示されていない時は何もしない
                }

                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => QuizWidget(
                          service: widget.service,
                          randomlySelectedProfiles: randomlySelectedProfiles)),
                );
              }),
        ],
      ),
    );
  }
}

// クイズのページ
class QuizWidget extends StatefulWidget {
  final IsarService service;
  final List<Profile> randomlySelectedProfiles;
  const QuizWidget(
      {super.key,
      required this.service,
      required this.randomlySelectedProfiles});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
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
              // const SizedBox(height: 40),
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

              // 次へボタン
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {},
              ),
              // TODO: 採点
              // TODO: 次のクイズへ遷移

              // const SizedBox(height: 200),
            ],
          ),
        ));
  }
}

class AnswerPanelWidget extends StatelessWidget {
  const AnswerPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnswerButtonWidget(name: '池田'),
        AnswerButtonWidget(name: '山田'),
        AnswerButtonWidget(name: '佐々木'),
        AnswerButtonWidget(name: '田中'),
      ],
    );
  }
}

// 一つの回答ボタン
class AnswerButtonWidget extends StatefulWidget {
  String name; // 表示する名前
  int count = 0; // 回答数
  bool isComplete = false; // 回答が完了したかどうか
  AnswerButtonWidget({super.key, required this.name});

  @override
  State<AnswerButtonWidget> createState() => _AnswerButtonWidgetState();
}

class _AnswerButtonWidgetState extends State<AnswerButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 最後の文字まで回答したら、成績発表
        if (widget.count < widget.name.length - 1) {
          widget.count++;
          setState(() {});
        } else {
          widget.isComplete = true;
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(60, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(widget.name[widget.count]),
    );
  }
}
