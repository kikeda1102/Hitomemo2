import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/services/isar_service.dart';

// プロフィール詳細ページ

class ProfileDetailPage extends StatefulWidget {
  final int id;
  final IsarService service;
  const ProfileDetailPage({super.key, required this.id, required this.service});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  // profileの読み込み
  // @override
  // void initState() {
  //   super.initState();
  //   // widget.service.listenToProfile(widget.id);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Profile')
          ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          // スクロール可能な画面
          child: SingleChildScrollView(
            child: StreamBuilder<Profile?>(
              stream: widget.service.listenToProfile(widget.id),
              builder:
                  (BuildContext context, AsyncSnapshot<Profile?> snapshot) {
                Profile? profile = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || profile == null) {
                  return const Center(child: Text('No data'));
                } else {
                  // 問題なくデータがある場合
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // 名前を表示
                      // TODO: Formによるvalidationを実装
                      TextFormField(
                        onChanged: (text) {
                          // profile.name = text;
                          profile = profile!.copyWith(name: text);
                          // DB保存
                          widget.service.putProfile(profile!);
                        },
                        controller: TextEditingController(text: profile.name),
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter the name',
                          border: UnderlineInputBorder(),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Please enter the name.";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // メモを表示
                      TextFormField(
                        onChanged: (text) {
                          profile!.memo = text;
                          // DB保存
                          widget.service.putProfile(profile!);
                        },
                        controller: TextEditingController(text: profile!.memo),
                        decoration: const InputDecoration(
                          labelText: 'Memo',
                          hintText: 'Enter the memo',
                          border: InputBorder.none,
                        ),
                        validator: (text) {
                          // TODO: validation
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // TODO: タグ

                      const SizedBox(height: 20),

                      // 削除ボタン
                      ElevatedButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          // 確認ダイアログを表示
                          showDialog(
                            context: context,
                            builder: (context) {
                              return _deleteDialog(context,
                                  profile: profile!, service: widget.service);
                            },
                          );
                        },
                      )
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

// 削除確認ダイアログ
AlertDialog _deleteDialog(BuildContext context,
    {required Profile profile, required IsarService service}) {
  return AlertDialog(
    title: const Text('Delete'),
    content: const Text('Are you sure to delete this profile?'),
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
          service.deleteProfile(profile.id);
          // 2つ前のページに戻る
          int count = 0;
          Navigator.popUntil(context, (_) => count++ >= 2);
        },
        // 色を赤に
        style: TextButton.styleFrom(
            backgroundColor: Colors.red, foregroundColor: Colors.white),
        child: const Text('Delete'),
      ),
    ],
  );
}
