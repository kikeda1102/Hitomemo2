import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/settings.dart';
import 'package:hito_memo_2/components/score_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hito_memo_2/components/edit_profile_widget.dart';

// プロフィール詳細ページ

class ProfileDetailPage extends StatefulWidget {
  final int id;
  final IsarService service;
  const ProfileDetailPage({super.key, required this.id, required this.service});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<Profile>(
        stream: widget.service.listenToProfile(widget.id),
        builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
          Profile profile = snapshot.data ??
              Profile(
                name: '',
                imageBytes: null,
                memos: List<String>.empty(),
              );

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // 名前
                  Center(
                    child: Text(
                      profile.name,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // scoreIcon
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: StreamBuilder(
                        stream: widget.service.listenToSettings(),
                        builder:
                            (context, AsyncSnapshot<List<Settings>> snapshot) {
                          List<Settings> settings = snapshot.data ??
                              List<Settings>.empty(growable: true);
                          if (snapshot.hasData) {
                            if (settings[0].presentQuizScore) {
                              return scoreIcon(profile, 35);
                            } else {
                              return const SizedBox(height: 0);
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ),
                  // memos
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => Card(
                        key: ValueKey(index.toString() + profile.memos[index]),
                        child: ListTile(
                          title: Text(profile.memos[index]),
                        ),
                      ),
                      itemCount: profile.memos.length,
                    ),
                  ),
                  // editボタン
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // 編集画面に遷移
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProfileWidget(
                              service: widget.service,
                              profile: profile,
                            ),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.edit),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
