import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hito_memo_2/services/isar_service.dart';
// import 'package:isar/isar.dart';

class EditProfileWidget extends StatefulWidget {
  final IsarService service;
  final Profile profile;
  const EditProfileWidget({
    required this.profile,
    required this.service,
    super.key,
  });

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final _formKey = GlobalKey<FormState>();
  final _memoTextController = TextEditingController();

  late Profile editingProfile;
  @override
  void initState() {
    super.initState();
    editingProfile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
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
                    key: ValueKey(
                        index.toString() + editingProfile.memos[index]),
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
                            .where((memo) =>
                                memo != editingProfile.memos[oldIndex])
                            .toList());
                    // newIndex番目にitemを挿入
                    editingProfile.memos.insert(newIndex, item);
                    setState(() {});
                    // print(newProfile.memos);
                  },
                ),
              ),
              // メモ追加
              Card(
                child: ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.addMemo,
                        border: const OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (text) {
                        // editingProfile.memosに新しくmemoを追加
                        editingProfile = editingProfile.copyWith(memos: [
                          ...editingProfile.memos,
                          _memoTextController.text
                        ]);
                        // textを空にする
                        _memoTextController.clear();
                        setState(() {});
                      },
                      onSaved: (text) {
                        // editingProfile.memosに新しくmemoを追加
                        editingProfile = editingProfile.copyWith(memos: [
                          ...editingProfile.memos,
                          _memoTextController.text
                        ]);
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
                        editingProfile = editingProfile.copyWith(memos: [
                          ...editingProfile.memos,
                          _memoTextController.text
                        ]);
                        // textを空にする
                        _memoTextController.clear();
                        setState(() {});
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 更新完了ボタン
                    ElevatedButton(
                      onPressed: () {
                        // DB更新処理
                        // validation
                        FormState? formKeyState = _formKey.currentState;
                        if (formKeyState != null && formKeyState.validate()) {
                          // DB更新
                          formKeyState.save(); // onSavedを呼び出す
                          widget.service.putProfile(editingProfile);
                          setState(() {});
                          Navigator.pop(context);
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.complete),
                    ),

                    // 削除ボタン
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => _deleteDialog(
                            context,
                            id: editingProfile.id,
                            service: widget.service,
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.delete),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          // 3つ前のページに戻る
          int count = 0;
          Navigator.popUntil(context, (_) => count++ >= 3);
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
