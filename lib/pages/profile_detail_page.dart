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
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false; // 編集中かどうかを判定する変数
  final _memoTextController = TextEditingController();
  late Profile newProfile; // newProfileをstate変数として宣言

  @override
  void initState() {
    super.initState();
    // profileを取得 更新用
    Future(() async {
      newProfile = await widget.service.getProfile(widget.id) ??
          Profile(
            name: '',
            imageBytes: null,
            memos: List<String>.empty(),
          );
    });
  }

  void updateNewProfile(newMemos) {
    newProfile = newProfile.copyWith(
      newMemos: newProfile.memos,
    );
    return;
  }

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
          } else if (!isEditing) {
            // 編集中でない場合
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
                ],
              ),
            );
          } else {
            // 編集中の場合
            return EditProfileWidget(
                newProfile: newProfile,
                formKey: _formKey,
                memoTextController: _memoTextController,
                setState: setState);
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        // color: Colors.grey[100],
        // surfaceTintColor: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 更新ボタン
            ElevatedButton(
              onPressed: () {
                // DB更新処理
                if (isEditing == true) {
                  // validation
                  FormState? formKeyState = _formKey.currentState;
                  if (formKeyState != null && formKeyState.validate()) {
                    // DB更新
                    formKeyState.save(); // onSavedを呼び出す
                    widget.service.putProfile(newProfile);
                    isEditing = false;
                    setState(() {});
                  }
                } else {
                  // 編集中でない場合
                  isEditing = true;
                  setState(() {});
                }
              },
              child: isEditing == false
                  ? Text(AppLocalizations.of(context)!.edit)
                  : Text(AppLocalizations.of(context)!.complete),
            ),

            // 削除ボタン
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => _deleteDialog(
                    context,
                    id: widget.id,
                    service: widget.service,
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        ),
      ),
    );
  }
}

// 削除確認ダイアログ
AlertDialog _deleteDialog(BuildContext context,
    {required int id, required IsarService service}) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context)!.delete),
    content: Text(AppLocalizations.of(context)!.areYouSure),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        // 色
        style: TextButton.styleFrom(
            backgroundColor: Colors.grey, foregroundColor: Colors.white),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          service.deleteProfile(id);
          // 2つ前のページに戻る
          int count = 0;
          Navigator.popUntil(context, (_) => count++ >= 2);
        },
        // 色を赤に 太文字
        style: TextButton.styleFrom(
            backgroundColor: Colors.red, foregroundColor: Colors.white),
        child: Text(AppLocalizations.of(context)!.delete,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    ],
  );
}
