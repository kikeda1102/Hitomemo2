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
    return const Center(
      child: Text('Settings'),
    );
  }
}
