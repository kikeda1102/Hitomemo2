import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart'; // プライバシーポリシーのページに飛ぶ用
import 'package:hito_memo_2/pages/register_profile_page.dart';
import 'package:hito_memo_2/pages/profile_detail_page.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/services/isar_service.dart';

// ホーム画面
class HomePage extends StatelessWidget {
  final IsarService service;

  // profilesのorderを現状順に更新する関数
  void refreshOrder(List<Profile> profiles, IsarService service) {
    for (int i = 0; i < profiles.length; i++) {
      profiles[i] = profiles[i].copyWith(order: i);
      // 更新をDBに保存
      service.putProfile(profiles[i]);
    }
  }

  // Futureバージョン (addボタン用)
  void refreshOrderFuture(Future<List<Profile>> profiles, IsarService service) {
    // sort
    profiles.then((value) {
      value.sort((a, b) => a.order.compareTo(b.order));
    });
    // 更新
    profiles.then((value) => refreshOrder(value, service));
  }

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
              //   delegate: ProfileSearchDelegate(service: isarService),
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
                    return const Center();
                  } else {
                    // dataをorder順にソートする
                    data.sort((a, b) => a.order.compareTo(b.order));
                    // ReorderableListViewで表示
                    return ReorderableListView.builder(
                      onReorder: (int oldIndex, int newIndex) {
                        // 下に移動した場合は、自分が消える分、newIndexを1減らす
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        // oldIndex番目の要素を削除し、その要素をitemに格納
                        final Profile item = data.removeAt(oldIndex);
                        // newIndex番目にitemを挿入
                        data.insert(newIndex, item);
                        // orderを更新
                        refreshOrder(data, service);
                      },
                      itemCount: data.length,
                      // ListViewの各要素を表示
                      itemBuilder: (BuildContext context, int index) {
                        // profileを取得
                        final profile = data[index];
                        return ListTile(
                          key: ValueKey(profile.id),
                          title: Text(profile.name),
                          // タグをChipで表示
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // profile.order.toString(), // for debug
                                profile.memo,
                              ),
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

                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ProfileDetailPage(
                                    id: profile.id, service: service)),
                          ),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // TODO: TagManagementPageの作成
                TextButton(
                  onPressed: () {
                    // タグ管理画面へ遷移
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           TagManagementPage(service: isarService),
                    //     ));
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 4),
                      Icon(
                        Icons.tag,
                        // color: Colors.white,
                        // size: 30,
                      ),
                      Text('Tags', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),

                // 新規perofile追加
                TextButton(
                  onPressed: () {
                    // 現在のprofilesを取得
                    Future<List<Profile>> profiles = service.getAllProfiles();
                    // orderの更新
                    refreshOrderFuture(profiles, service);
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
