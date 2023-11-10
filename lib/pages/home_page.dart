import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart'; // プライバシーポリシーのページに飛ぶ用
import 'package:hito_memo_2/models/settings.dart';
import 'package:hito_memo_2/components/profile_search_delegate.dart';
import 'package:hito_memo_2/pages/register_profile_page.dart';
import 'package:hito_memo_2/pages/profile_detail_page.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/pages/setting_page.dart';
import 'package:hito_memo_2/pages/quiz_gate_page.dart';

// メイン画面
class MainPage extends StatefulWidget {
  final IsarService service;
  const MainPage({super.key, required this.service});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // ページのindex BottomNavigationBarで切り替える
  int _currentIndex = 0;
  // BottomNavigationBarのindexを変更する関数
  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  // profilesのorderを現状順に更新する関数
  void refreshOrder(List<Profile> profiles, IsarService service) {
    for (int i = 0; i < profiles.length; i++) {
      profiles[i] = profiles[i].copyWith(newOrder: i);
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

  @override
  Widget build(BuildContext context) {
    // 切り替えるページたち
    final pageWidgets = [
      HomePage(service: widget.service),
      QuizGatePage(service: widget.service),
      SettingsPage(service: widget.service),
    ];

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const ListTile(
              title: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text('HitoMemo', style: TextStyle(fontSize: 25)),
                    SizedBox(height: 10),
                    Text('Version 1.0.0'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Link(
              // 開きたいURL
              uri: Uri.parse('https://kikeda1102.github.io/Hitomemo2/'),
              target: LinkTarget.self, // 独立したブラウゼで開く
              builder: (BuildContext context, FollowLink? followLink) {
                return TextButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: followLink,
                  label: const Text('Privacy policy'),
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
              showSearch(
                context: context,
                delegate: ProfileSearchDelegate(service: widget.service),
              );
            },
          ),
        ],
      ),
      // profileの一覧表示
      body: pageWidgets.elementAt(_currentIndex),

      // 新規追加
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 現在のprofilesを取得
          Future<List<Profile>> profiles = widget.service.getAllProfiles();
          // orderの更新
          refreshOrderFuture(profiles, widget.service);
          // RegisterProfilePageへ遷移
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterProfilePage(
                service: widget.service,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentIndex, // 現在選択されているIndex
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped, // 選択された時の処理
      ),
    );
  }
}

// ホーム画面
class HomePage extends StatelessWidget {
  final IsarService service;

  // profilesのorderを現状順に更新する関数
  void refreshOrder(List<Profile> profiles, IsarService service) {
    for (int i = 0; i < profiles.length; i++) {
      profiles[i] = profiles[i].copyWith(newOrder: i);
      // 更新をDBに保存
      service.putProfile(profiles[i]);
    }
  }

  const HomePage({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  // print(data);
                  return const Center(child: Text('Tap + button to register.'));
                } else {
                  // TODO: createdAt/updatedAtの並び順での表示への変更を可能に
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
                      // profileを表示
                      return StreamBuilder(
                        key: ValueKey(profile.id),
                        stream: service.listenToSettings(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Settings>> snapshot) {
                          final data = snapshot.data; // 静的解析が効くように変数に格納
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          } else if (data == null || data.isEmpty) {
                            return const Text('Tap + button to register.');
                          } else {
                            return Card(
                              key: ValueKey(profile.id),
                              child: ListTile(
                                title: Text(profile.name),
                                // memosをsubtitleに表示
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // profile.order.toString(), // for debug
                                      profile.memos
                                          .join('     '), // memosの要素を改行で結合して表示
                                    ),
                                  ],
                                ),
                                // quizのscore表示
                                trailing: data[0].presentQuizScore == true
                                    ? Text(
                                        // nullなら何も表示しない
                                        profile.numberOfIncorrectTaps == null
                                            ? ''
                                            : '${profile.calculateCorrectRate()}',
                                        // correctRateRankに従って色を変える
                                        style: profile.correctRateRank() ==
                                                'perfect'
                                            ? const TextStyle(
                                                color: Colors.green,
                                                fontSize: 15)
                                            : profile.correctRateRank() ==
                                                    'good'
                                                ? const TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 15)
                                                : const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15),
                                      )
                                    : null,

                                // profile detailへ遷移
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ProfileDetailPage(
                                          id: profile.id, service: service)),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
