import 'package:flutter/material.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// プロフィール新規追加画面

class RegisterProfilePage extends StatefulWidget {
  final IsarService service;
  const RegisterProfilePage({required this.service, Key? key})
      : super(key: key);
  @override
  State<RegisterProfilePage> createState() => _RegisterProfilePageState();
}

class _RegisterProfilePageState extends State<RegisterProfilePage> {
  // 空の新規Profileを作成
  Profile newProfile = Profile(
    name: '',
    imageBytes: null,
    memos: List<String>.empty(),
  );
  final _formKey = GlobalKey<FormState>(); // Validation用
  // メモを入力するTextField
  final _memoTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // 名前を入力するTextField
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
                SizedBox(
                  // デバイスの高さの半分
                  height: MediaQuery.of(context).size.height / 2,
                  child: ReorderableListView.builder(
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(index),
                      child: ListTile(
                        leading: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // memosからindex番目の要素を削除
                            newProfile.memos = newProfile.memos
                                .where(
                                    (memo) => memo != newProfile.memos[index])
                                .toList();
                            setState(() {});
                          },
                        ),
                        title: TextFormField(
                          initialValue: newProfile.memos[index],
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.memos,
                            border: const OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            newProfile.memos[index] = value!;
                          },
                        ),
                        trailing: ReorderableDragStartListener(
                          index: index,
                          child: const Icon(Icons.drag_handle),
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
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        registerMemo(_memoTextController.text);
                        setState(() {});
                      },
                    ),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.addMemo,
                        border: const OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (text) {
                        registerMemo(text);
                        setState(() {});
                      },
                      controller: _memoTextController,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            // DB更新処理
            // validation
            FormState? formKeyState = _formKey.currentState;
            if (formKeyState != null && formKeyState.validate()) {
              // DB更新
              formKeyState.save(); // onSavedを呼び出す
              widget.service.putProfile(newProfile);
              Navigator.pop(context);
            }
          },
          child: Text(AppLocalizations.of(context)!.register),
        ),
      ),
    );
  }

  // メモを追加するメソッド
  Function() registerMemo(String text) {
    // Enterされたとき、newProfile.memosに新しくmemoを追加
    newProfile.memos = [...newProfile.memos, text];
    // textを空にする
    _memoTextController.clear();
    return () {};
  }
}
