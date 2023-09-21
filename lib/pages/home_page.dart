import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart'; // プライバシーポリシーのページに飛ぶ用
import 'package:hito_memo_2/pages/register_profile_page.dart'; // TODO: プロフィール追加画面
// import 'package:hito_memo_2/pages/profile_detail_page.dart'; // TODO: プロフィール詳細画面
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/services/isar_service.dart';

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
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 検索機能
              // showSearch(
              //   context: context,
              //   delegate: ProfileSearchDelegate(service: service),
              // );
            },
          ),
        ],
      ),
      // profileの一覧表示
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // profileの一覧をStreamとして表示
              child: StreamBuilder<List<Profile>>(
                stream: service.listenToAllProfiles(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Profile>> snapshot) {
                  final data = snapshot.data; // 静的解析が効くように変数に格納
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (data == null || data.isEmpty) {
                    return const Center(child: Text('No data'));
                  } else {
                    // TODO: dataをソートする
                    return ReorderableListView.builder(
                      onReorder: (int oldIndex, int newIndex) {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final Profile item = data.removeAt(
                            oldIndex); // oldIndex番目の要素を削除し、その要素をitemに格納
                        data.insert(newIndex, item); // newIndex番目にitemを挿入
                        // orderを更新
                        for (int i = 0; i < data.length; i++) {
                          data[i] = data[i].copyWith(
                            order: i,
                          );
                          // 更新したデータを保存
                          service.putProfile(data[i]);
                        }
                      },
                      itemCount: data.length,
                      // ListViewの各要素を表示
                      itemBuilder: (BuildContext context, int index) {
                        final profile = data[index];

                        return ListTile(
                          key: ValueKey(profile.id),
                          title: Text(profile.name),
                          trailing: Text(profile.memo), // TODO: UIの改善
                          // Chipを表示
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile.order.toString()), // debug用
                              if (profile.personalTags.isNotEmpty)
                                Wrap(
                                  spacing: 4,
                                  runSpacing: -12,
                                  children: profile.personalTags
                                      .map((tag) => Chip(
                                            label: Text(
                                              tag,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ))
                                      .toList(),
                                ),
                            ],
                          ),
                          // TODO: ProfileDetailPageを作る
                          // onTap: () => Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //       builder: (context) => ProfileDetailPage(
                          //           id: profile.id, service: service)),
                          // ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: BottomAppBar(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                // TODO: personalTag omponent

                // 新規perofile追加
                TextButton(
                  onPressed: () {
                    // RegisterProfilePageへ遷移
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterProfilePage(
                          service: service,
                        ),
                      ),
                    );
                  },
                  child: const Column(
                    children: [
                      SizedBox(height: 4),
                      Icon(
                        Icons.add_circle,
                        // color: Colors.white,
                        // size: 30,
                      ),
                      Text('New', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
