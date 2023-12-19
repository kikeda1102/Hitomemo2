import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
// import 'package:hito_memo_2/services/isar_service.dart';
// import 'package:hito_memo_2/models/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileWidget extends StatelessWidget {
  final Profile newProfile;
  final GlobalKey<FormState> _formKey;
  final TextEditingController _memoTextController;
  final StateSetter setState;
  const EditProfileWidget(
      {super.key,
      required this.newProfile,
      required GlobalKey<FormState> formKey,
      required TextEditingController memoTextController,
      required this.setState})
      : _formKey = formKey,
        _memoTextController = memoTextController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 名前
            TextFormField(
              style: const TextStyle(
                fontWeight: FontWeight.bold, // ここで太文字に設定
              ),
              initialValue: newProfile.name,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.name,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.enterTheName;
                }
                return null;
              },
              onSaved: (value) {
                newProfile.name = value!;
              },
            ),
            const SizedBox(height: 20),
            // memos
            Expanded(
              child: ReorderableListView.builder(
                itemBuilder: (context, index) => Card(
                  key: ValueKey(index.toString()+newProfile.memos[index]),
                  // key: UniqueKey(),
                  child: ListTile(
                    leading: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_handle),
                    ),
                    title: TextFormField(
                      initialValue: newProfile.memos[index],
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.memo,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enterTheMemo;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        newProfile.memos[index] = value!;
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        size: 20,
                      ),
                      onPressed: () {
                        // memosからindex番目の要素を削除
                        newProfile.memos = newProfile.memos
                            .where((memo) => memo != newProfile.memos[index])
                            .toList();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                itemCount: newProfile.memos.length,
                onReorder: (oldIndex, newIndex) {
                  // 下に移動した場合は、自分が消える分、newIndexを1減らす
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  // oldIndex番目の要素を削除し、その要素をitemに格納
                  final item = newProfile.memos[oldIndex];
                  // newProfile.memosからoldIndex番目の要素を削除
                  newProfile.memos = newProfile.memos
                      .where((memo) => memo != newProfile.memos[oldIndex])
                      .toList();
                  // newIndex番目にitemを挿入
                  newProfile.memos.insert(newIndex, item);
                  setState(() {});
                  // print(newProfile.memos);
                },
              ),
            ),
            Card(
              child: ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.addMemo,
                      border: const OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (text) {
                      // Enterされたとき、newProfile.memosに新しくmemoを追加
                      newProfile.memos = [...newProfile.memos, text];
                      // textを空にする
                      _memoTextController.clear();
                      setState(() {});
                    },
                    controller: _memoTextController,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // newProfile.memosに新しくmemoを追加
                      newProfile.memos = [
                        ...newProfile.memos,
                        _memoTextController.text
                      ];
                      // textを空にする
                      _memoTextController.clear();
                      setState(() {});
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
