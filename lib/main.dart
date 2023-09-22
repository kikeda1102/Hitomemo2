import 'package:flutter/material.dart';
import 'package:hito_memo_2/pages/home_page.dart'; // 開始画面用
// import 'package:hito_memo_2/modles/general_tag.dart'; // generalTagの初期値追加用
import 'package:hito_memo_2/services/isar_service.dart'; // IsarDBの操作用

void main() async {
  // IsarDBの初期化
  WidgetsFlutterBinding.ensureInitialized();
  // isar_service.dartで定義した、IsarServiceクラスのインスタンス化
  final isarService = IsarService();
  // アプリの起動
  runApp(MyApp(service: isarService));
}

class MyApp extends StatelessWidget {
  final IsarService service;
  const MyApp({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // デバッグバナーを非表示
      title: 'hitomemo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(service: service),
      // home: const Placeholder(), // for debug
    );
  }
}
