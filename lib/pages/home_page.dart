import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart'; // プライバシーポリシーのページに飛ぶ用
import 'package:hito_memo_2/pages/add_profile_page.dart'; // プロフィール追加画面
import 'package:hito_memo_2/pages/profile_detail_page.dart'; // プロフィール詳細画面

// ホーム画面
class HomePage extends StatelessWidget {
  final IsarService service;
  const HomePage({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              const ListTile(
                title: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text('Hitomemo'),
                      SizedBox(height: 10),
                      Text('Version 1.0.0'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Link(
                // 開きたいURL
                uri: Uri.parse(
                    'https://kikeda1102.github.io/tt_scoreboard_LP/'), // TODO: プライバシーポリシーのページを作る
                target: LinkTarget.self, // 独立したブラウゼで開く
                builder: (BuildContext context, FollowLink? followLink) {
                  return TextButton.icon(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: followLink,
                    label: const Text('Privacy Policy'),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          // title: const Text('People List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // 検索機能
                showSearch(
                  context: context,
                  delegate: ProfileSearchDelegate(service: service),
                );
              },
            ),
          ],
        ),
        // profileの一覧表示
        body: Column(children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                // profileの一覧をStreamとして表示
                child: StreamBuilder<List<Profile>>(
                  stream: service.listenToProfiles(),
                  builder: (BuildContext context, AsyncSnapshot<List<Profile> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    } else if (snapshot.data == null || snapshot.data.isEmpty ) {
                      return const Text('No data');
                    } else {
                      // TODO: snapshot.dataをソートする
                      rerturn ReorderableListView.builder(
                        onReorder: (int oldIndex, int newIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final Profile item = snapshot.data.removeAt(oldIndex); // oldIndex番目の要素を削除し、その要素をitemに格納
                        }
                      )
                    }
                  } // profileの一覧をlisten
                )),
          )
        ]));
  }
}
