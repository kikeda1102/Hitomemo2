import 'package:flutter/material.dart';
import 'package:hito_memo_2/main.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/settings.dart';

// 設定ページ

class SettingsPage extends StatefulWidget {
  final IsarService service;

  const SettingsPage({super.key, required this.service});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.service.listenToSettings(),
      builder: (context, AsyncSnapshot<List<Settings>> snapshot) {
        // クイズの正答率を表示するか
        Future<void> toggleQuizScore(bool value) async {
          setState(() {
            // DBに保存
            widget.service.putSettings(
                snapshot.data![0].copyWith(newPresentQuizScore: value));
            // print('value = $value');
            // print(
            //     'snapshot.data![0].presentQuizScore = ${snapshot.data![0].presentQuizScore}');
          });
        }

        if (snapshot.hasData) {
          // print('snapshot.data = ${snapshot.data}');
          return _buildSettingsPage(snapshot.data!, toggleQuizScore);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Widget _buildSettingsPage(
    List<Settings> settings, Function(bool) toggleQuizScore) {
  return ValueListenableBuilder(
    valueListenable: localeVariable,
    builder: (context, value, _) => SettingsList(
      sections: [
        // TODO: internationalization
        SettingsSection(
          title: const Text('言語'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                value: Text(value.toString()),
                // TODO: materialでページ遷移
                onPressed: (BuildContext context) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LanguageSettingsPage(
                          // service: widget.service,
                          ),
                    ),
                  );
                }),
          ],
        ),
        SettingsSection(
          title: const Text('一般'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              title: const Text('クイズの正答率を表示する'),
              initialValue: settings[0].presentQuizScore,
              onToggle: toggleQuizScore,
            ),
            // SettingsTile.switchTile(
            //   title: const Text('登録日時を表示する'),
            //   initialValue: true,
            //   onToggle: togglePresentCreatedAt,
            // ),
          ],
        ),
      ],
    ),
  );
}

// 言語選択
void switchLocale(BuildContext context) {
  if (localeVariable.value == const Locale('en')) {
    localeVariable.value = const Locale('ja');
  } else {
    localeVariable.value = const Locale('en');
  }
}

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            ElevatedButton(
              child: const Text('English'),
              onPressed: () {
                switchLocale(context);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              child: const Text('日本語'),
              onPressed: () {
                switchLocale(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
