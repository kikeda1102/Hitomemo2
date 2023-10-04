import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/pages/profile_detail_page.dart';

// 検索機能
class ProfileSearchDelegate extends SearchDelegate<Profile> {
  final IsarService service;
  ProfileSearchDelegate({
    required this.service,
    // super.searchFieldStyle = const TextStyle(color: Colors.white),
  });

  // 色の設定
  // @override
  // ThemeData appBarTheme(BuildContext context) {
  //   return Theme.of(context).copyWith(
  //     primaryColor: Colors.blueGrey,
  //     inputDecorationTheme: InputDecorationTheme(
  //       hintStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
  //     ),
  //   );
  // }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // 検索クエリをクリアするボタン
      IconButton(
        icon: const Icon(Icons.clear),
        tooltip: 'Clear',
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  // 検索バーの左側の戻るボタン
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      tooltip: 'Back',
      onPressed: () => close(
          context,
          Profile(
            name: '',
            memos: [],
          )),
    );
  }

  // 検索結果の表示
  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<Profile>>(
        stream: service.listenToAllProfiles(),
        builder: (context, AsyncSnapshot<List<Profile>> snapshot) {
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            final results = snapshot.data!
                .where((profile) =>
                    profile.name.toLowerCase().contains(query.toLowerCase()) ||
                    profile.memos.any((memo) =>
                        memo.toLowerCase().contains(query.toLowerCase())))
                .toList();
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.grey,
                thickness: 1.0,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final profile = results[index];
                return ListTile(
                  title: Text(profile.name),
                  trailing: Text(profile.memos.join(' ')),
                  // タグ
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (profile.memos.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: -12,
                          children: profile.memos
                              .map((memo) => Chip(
                                    label: Text(
                                      memo,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileDetailPage(id: profile.id, service: service),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          } else {
            return const Center(
                child: Text(
              'Add a new person by tapping the + button.',
              style: TextStyle(fontSize: 15),
            ));
          }
        },
      ),
    );
  }

  // 検索候補の表示
  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<Profile>>(
        stream: service.listenToAllProfiles(),
        builder: (context, AsyncSnapshot<List<Profile>> snapshot) {
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            final results = snapshot.data!
                .where((profile) =>
                    profile.name.toLowerCase().contains(query.toLowerCase()) ||
                    profile.memos.any((memo) =>
                        memo.toLowerCase().contains(query.toLowerCase())))
                .toList();
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.grey,
                thickness: 1.0,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final profile = results[index];
                return ListTile(
                  title: Text(profile.name),
                  trailing: Text(profile.memos.join(' ')),
                  // タグ
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (profile.memos.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: -12,
                          children: profile.memos
                              .map((memo) => Chip(
                                    label: Text(
                                      memo,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileDetailPage(id: profile.id, service: service),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          } else {
            return const Center(
                child: Text(
              'Add a new person by tapping the + button.',
              style: TextStyle(fontSize: 15),
            ));
          }
        },
      ),
    );
  }
}
