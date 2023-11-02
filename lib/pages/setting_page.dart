import 'package:flutter/material.dart';

// 設定ページ

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: settings page
    // クイズの結果を表示するか
    // 登録日時を表示するか
    return const Center(
      child: Text('Settings'),
    );
  }
}
