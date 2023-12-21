import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:hito_memo_2/services/isar_service.dart';

class EditProfileWidget extends StatefulWidget {
  final Profile profile;
  final GlobalKey<FormState> _formKey;
  final TextEditingController _memoTextController;
  const EditProfileWidget({
    required this.profile,
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController memoTextController,
  })  : _formKey = formKey,
        _memoTextController = memoTextController;

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late Profile editingProfile;
  @override
  void initState() {
    super.initState();
    editingProfile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
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
              initialValue: editingProfile.name,
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
                editingProfile = editingProfile.copyWith(name: value!);
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            // memos
            Expanded(
              child: ReorderableListView.builder(
                itemBuilder: (context, index) => Card(
                  key: ValueKey(index.toString() + editingProfile.memos[index]),
                  child: ListTile(
                    leading: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_handle),
                    ),
                    title: TextFormField(
                      initialValue: editingProfile.memos[index],
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
                        editingProfile.memos[index] = value!;
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        size: 20,
                      ),
                      onPressed: () {
                        // memosからindex番目の要素を削除
                        editingProfile = editingProfile.copyWith(
                            memos: List.from(editingProfile.memos)
                              ..removeAt(index));
                        setState(() {});
                      },
                    ),
                  ),
                ),
                itemCount: editingProfile.memos.length,
                onReorder: (oldIndex, newIndex) {
                  // 下に移動した場合は、自分が消える分、newIndexを1減らす
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  // oldIndex番目の要素を削除し、その要素をitemに格納
                  final item = editingProfile.memos[oldIndex];
                  // newProfile.memosからoldIndex番目の要素を削除
                  editingProfile = editingProfile.copyWith(
                      memos: editingProfile.memos
                          .where(
                              (memo) => memo != editingProfile.memos[oldIndex])
                          .toList());
                  // newIndex番目にitemを挿入
                  editingProfile.memos.insert(newIndex, item);
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
                      // updateNewProfile(
                      //   newProfile: newProfile,
                      //   newMemos: [...newProfile.memos, text],
                      // );
                      setState(() {});

                      // textを空にする
                      widget._memoTextController.clear();
                      setState(() {});
                    },
                    controller: widget._memoTextController,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // newProfile.memosに新しくmemoを追加
                      editingProfile = editingProfile.copyWith(memos: [
                        ...editingProfile.memos,
                        widget._memoTextController.text
                      ]);
                      // textを空にする
                      widget._memoTextController.clear();
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
