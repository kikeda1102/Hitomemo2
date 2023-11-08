import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/settings.dart';

// 設定ページ
// TODO: 設定の永続化

class SettingsPage extends StatefulWidget {
  final IsarService service;

  const SettingsPage({super.key, required this.service});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Settings settings = Settings(
    language: 'ja',
    presentQuizScore: true,
    presentCreatedAt: false,
  );

  // クイズの正答率を表示するか
  Future<void> toggleQuizScore(bool value) async {
    setState(() {
      value = !value;
      widget.service.putSettings(settings.copyWith(newPresentQuizScore: value));
    });
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      settings = await widget.service.getSettings() ??
          Settings(
            language: 'ja',
            presentQuizScore: true,
            presentCreatedAt: false,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        // TODO: internationalization
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
              initialValue: settings.presentQuizScore,
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
    );
  }
}
