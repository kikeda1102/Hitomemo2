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
  double _value = 6;
  double _startValue = 0;
  double _endValue = 0;

  void _changeSlider(double e) => setState(() {
        _value = e;
      });
  void _startSlider(double e) => setState(() {
        _startValue = e;
      });
  void _endSlider(double e) => setState(() {
        _endValue = e;
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('Quiz'),
          ),

          const SizedBox(height: 40),

          const Text('Number of questions'),

          // TODO: スライダーの実装

          // 問題数を選択するスライダー
          Slider(
            value: _value,
            min: 1,
            max: 100,
            divisions: 99, // 目盛の数値を決めるための値で、(max - min) / divisionsの計算で値が決定する
            label: '$_value',
            onChanged: _changeSlider,
            onChangeStart: _startSlider,
            onChangeEnd: _endSlider,
          ),

          const SizedBox(height: 60),

          // Startボタン
          ElevatedButton(
              child: const Text('Start'),
              onPressed: () async {
                // データの取得
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

// Quizクラスの定義
// class Quiz {
//   Profile profile;

// }

// クイズのページ
class QuizWidget extends StatefulWidget {
  final IsarService service;
  List<Profile> randomlySelectedProfiles;
  QuizWidget(
      {super.key,
      required this.service,
      required this.randomlySelectedProfiles});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  @override
  Widget build(BuildContext context) {
    // // profilesを取得
    // List<Profile> profiles = widget.service.getAllProfiles().then((value) {
    //   return value;
    // });

    return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'), // TODO: 何問目か表示
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // memos
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: ListView.builder(
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(index),
                      child: ListTile(
                        title: Text(
                            widget.randomlySelectedProfiles[0].memos[index]),
                      ),
                    ),
                    itemCount: widget.randomlySelectedProfiles[0].memos.length,
                  )

                  //  StreamBuilder<List<Profile>>(
                  //   stream: widget.service.listenToAllProfiles(),
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<List<Profile>> snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const Center(child: CircularProgressIndicator());
                  //     } else if (snapshot.hasError) {
                  //       return Text('Error: ${snapshot.error}');
                  //     } else if (!snapshot.hasData) {
                  //       return const Center(child: Text('No data'));
                  //     } else {
                  //       // 問題なくデータがある場合
                  //       Profile profile = snapshot.data!.first;

                  //       // memosを新変数に格納
                  //       List<String> memos = profile.memos;
                  //       return ListView.builder(
                  //         itemBuilder: (context, index) => Card(
                  //           key: ValueKey(index),
                  //           child: ListTile(
                  //             title: Text(memos[index]),
                  //           ),
                  //         ),
                  //         itemCount: memos.length,
                  //       );
                  //     }
                  //   },
                  // ),
                  ),
            ),

            // 入力欄
            const Text('Who is this?'),
            Padding(
              padding: const EdgeInsets.all(30),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Answer',
                ),
              ),
            ),

            // 次へボタン
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {},
            ),
            // TODO: 採点
            // TODO: 次のクイズへ遷移

            const SizedBox(height: 200),
          ],
        ));
  }
}
