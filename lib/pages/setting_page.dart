import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          });
        }

        if (snapshot.hasData) {
          return SettingsList(
            sections: [
              // TODO: internationalization
              SettingsSection(
                title: Text(AppLocalizations.of(context)!.languageSettings),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                      leading: const Icon(Icons.language),
                      title:
                          Text(AppLocalizations.of(context)!.languageSettings),
                      value:
                          Text(_getDisplayLanguage(snapshot.data![0].language)),
                      onPressed: (BuildContext context) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LanguageSettingsPage(
                              service: widget.service,
                              settings: snapshot.data![0],
                            ),
                          ),
                        );
                      }),
                ],
              ),
              SettingsSection(
                title: Text(AppLocalizations.of(context)!.generalSetttings),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    title: Text(AppLocalizations.of(context)!.presentQuizScore),
                    initialValue: snapshot.data![0].presentQuizScore,
                    onToggle: toggleQuizScore,
                  ),
                ],
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

String _getDisplayLanguage(String languageCode) {
  switch (languageCode) {
    case 'ja':
      return '日本語';
    case 'en':
      return 'English';
    default:
      return '-';
  }
}

class LanguageSettingsPage extends StatelessWidget {
  final IsarService service;
  final Settings settings;

  const LanguageSettingsPage(
      {super.key, required this.service, required this.settings});

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
                switchLocaleToEn(service, settings);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              child: const Text('日本語'),
              onPressed: () {
                switchLocaleToJa(service, settings);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 言語選択
// 日本語に
void switchLocaleToJa(IsarService service, Settings settings) {
  // DBに保存
  service.putSettings(settings.copyWith(newLanguage: 'ja'));
}

// 英語に
void switchLocaleToEn(IsarService service, Settings settings) {
  // DBに保存
  service.putSettings(settings.copyWith(newLanguage: 'en'));
}
