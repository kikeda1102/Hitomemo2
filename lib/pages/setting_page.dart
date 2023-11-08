import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hito_memo_2/main.dart';

// 設定ページ

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // クイズの正答率を表示するか
  Future<void> toggleQuizScore(bool value) async {
    // TODO: implement toggleQuizScore
    setState(() {
      settingUI.presentQuizScore = !settingUI.presentQuizScore;
    });
    settingUI.callSetState();
    print('value=$value');
    print('settingUI.presentQuizScore = ${settingUI.presentQuizScore}');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: settings page
    // クイズの結果を表示するか
    // 登録日時を表示するか
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text('言語'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              value: const Text('日本語'),
            ),
          ],
        ),
        SettingsSection(
          title: const Text('一般'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              title: const Text('クイズの正答率を表示する'),
              initialValue: true,
              onToggle: toggleQuizScore,
            )
          ],
        ),
      ],
    );
  }
}
