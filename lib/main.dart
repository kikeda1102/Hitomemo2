import 'package:flutter/material.dart';
import 'package:hito_memo_2/pages/home_page.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  // IsarDBを使うための初期化の保証
  WidgetsFlutterBinding.ensureInitialized();
  // setup Isar service
  final IsarService service = IsarService();

  // アプリの起動
  runApp(MyApp(service: service));
}

// localizations
mixin AppLocale {
  static const String title = 'title';

  static const Map<String, dynamic> EN = {title: 'Localization'};
  static const Map<String, dynamic> JA = {title: 'ローカリゼーション'};
}

class MyApp extends StatefulWidget {
  final IsarService service;
  const MyApp({Key? key, required this.service}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 設定
  late Settings settings;

  @override
  void initState() {
    super.initState();
    // 設定がなければ初期値を設定、DB保存
    Future(() async {
      if (await widget.service.getSettings() == null) {
        // print(
        //     'widget.service.getSettings() = ${await widget.service.getSettings()}');
        settings = Settings(
          language: 'ja',
          presentQuizScore: true,
          presentCreatedAt: true,
        );
        // 保存
        widget.service.putSettings(settings);
      }
      // load
      settings = await widget.service.getSettings() ??
          Settings(
            language: 'ja',
            presentQuizScore: true,
            presentCreatedAt: true,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: localeVariable,
      builder: (context, value, _) => MaterialApp(
        debugShowCheckedModeBanner: false, // デバッグバナーを非表示
        title: 'hitomemo',
        locale: value,
        localizationsDelegates: AppLocalizations.localizationsDelegates, // 追加
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.lightBlue,
          // brightness: Brightness.dark, // ダークモード
          // primarySwatch: Colors.blueGrey,
          // accentColor: Colors.blueAccent,
        ),
        home: MainPage(service: widget.service),
        // home: const Placeholder(), // for debug
      ),
    );
  }
}

// TODO: 永続化
var localeVariable = ValueNotifier<Locale>(
  Locale('en'),
);
