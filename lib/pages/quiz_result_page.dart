import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/quiz_manager.dart';
import 'package:hito_memo_2/pages/quiz_gate_page.dart';

// 結果を表示するページ
class QuizResultPage extends StatefulWidget {
  final IsarService service;
  const QuizResultPage({super.key, required this.service});

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 自動で生成される戻るボタンを無効化
        leading: MyBackButton(service: widget.service),
        title: const Text('Result'),
      ),
      body: const Center(
        child: Text('Result'),
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
