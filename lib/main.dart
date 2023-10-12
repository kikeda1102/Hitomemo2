import 'package:flutter/material.dart';
import 'package:hito_memo_2/pages/home_page.dart'; // 開始画面用
// import 'package:hito_memo_2/modles/general_tag.dart'; // generalTagの初期値追加用
import 'package:hito_memo_2/services/isar_service.dart'; // IsarDBの操作用

void main() async {
  // IsarDBを使うための初期化の保証
  WidgetsFlutterBinding.ensureInitialized();
  // アプリの起動
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // デバッグバナーを非表示
      title: 'hitomemo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blueGrey,
      ),
      home: MainPage(),
      // home: const Placeholder(), // for debug
    );
  }
}
