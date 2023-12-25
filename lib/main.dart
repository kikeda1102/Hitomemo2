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
        settings = Settings(
          language: 'ja',
          presentQuizScore: true,
          presentCreatedAt: true,
        );
        // 保存
        widget.service.putSettings(settings);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.service.listenToSettings(),
      builder: (context, AsyncSnapshot<List<Settings>> snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.isNotEmpty) {
          settings = snapshot.data![0];
          return MaterialApp(
            debugShowCheckedModeBanner: false, // デバッグバナーを非表示
            title: 'hitomemo',
            locale: Locale(settings.language),
            localizationsDelegates:
                AppLocalizations.localizationsDelegates, // 追加
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.lightBlue,
            ),
            home: MainPage(service: widget.service),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
