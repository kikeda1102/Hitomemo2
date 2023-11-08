import 'package:flutter/material.dart';
import 'package:hito_memo_2/pages/home_page.dart'; // 開始画面用
import 'package:hito_memo_2/services/isar_service.dart';

void main() async {
  // IsarDBを使うための初期化の保証
  WidgetsFlutterBinding.ensureInitialized();
  // setup Isar service
  final IsarService service = IsarService();

  // アプリの起動
  runApp(MyApp(service: service));
}

class MyApp extends StatefulWidget {
  final IsarService service;
  const MyApp({Key? key, required this.service}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool presentQuizScore = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // デバッグバナーを非表示
      title: 'hitomemo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlue,
        // brightness: Brightness.dark, // ダークモード
        // primarySwatch: Colors.blueGrey,
        // accentColor: Colors.blueAccent,
      ),
      home: MainPage(service: widget.service),
      // home: const Placeholder(), // for debug
    );
  }
}
