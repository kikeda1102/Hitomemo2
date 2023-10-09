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
  final _formKey = GlobalKey<FormState>(); // Validation用

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Profile')
          ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),

            // 名前
            child: StreamBuilder<Profile>(
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
                  // 問題なくデータがある場合
                  return Column(
                    children: [
                      // 名前
                      Text(
                        profile.name,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          // memos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: StreamBuilder<Profile>(
                stream: widget.service.listenToProfile(widget.id),
                builder:
                    (BuildContext context, AsyncSnapshot<Profile> snapshot) {
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
                    // 問題なくデータがある場合
                    return ReorderableListView.builder(
                      itemBuilder: (context, index) => ListTile(
                        key: ValueKey(index),
                        title: Text(profile.memos[index]),
                      ),
                      itemCount: profile.memos.length,
                      onReorder: (oldIndex, newIndex) => setState(
                        () {
                          // 下に移動した場合は、自分が消える分、newIndexを1減らす
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          // TODO: removeAtをうまく定義しなおし、reorderを実装する
                          // oldIndex番目の要素を削除し、その要素をitemに格納
                          // final item = profile.memos.removeAt(oldIndex);
                          // newIndex番目にitemを挿入
                          // profile.memos.insert(newIndex, item);
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),

          // 削除ボタン
          Padding(
            padding: const EdgeInsets.all(30),
            child: StreamBuilder<Profile>(
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
                  // 問題なくデータがある場合
                  return ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => _deleteDialog(
                          context,
                          profile: profile,
                          service: widget.service,
                        ),
                      );
                    },
                    child: const Text('Delete'),
                  );
                }
              },
            ),
          ),
        ],
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
