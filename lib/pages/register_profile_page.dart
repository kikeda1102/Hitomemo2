import 'package:flutter/material.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/profile.dart';
// import 'package:hito_memo_2/components/add_tag_component.dart';

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
  // 名前を入力するTextField
  // final _nameTextController = TextEditingController();
  // メモを入力するTextField
  // final _memoTextController = TextEditingController();
  // Stateの更新
  void updateProfile() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Register New Person'),
          ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                // 名前を入力するTextField
                Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextFormField(
                    // controller: _nameTextController,
                    decoration: const InputDecoration(
                      // labelText: 'Name',
                      hintText: 'Enter the name',
                    ),
                    onChanged: (text) {
                      // 名前が入力されるとnewProfileに反映
                      newProfile.name = text;
                    },
                    validator: (text) {
                      // 名前が入力されていない場合はエラーを返す
                      if (text == null || text.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // memosを表示
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    children: [
                      const Text('Memos'),
                      const SizedBox(height: 10),
                      // memosを表示
                      if (newProfile.memos.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: -12,
                          children: newProfile.memos
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
                ),

                const SizedBox(height: 20),

                // memosを作成
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    onFieldSubmitted: (text) {
                      // メモが入力されたとき、newProfileに反映
                      newProfile.memos = [...newProfile.memos, text];
                      setState(() {});
                    },
                    // controller: _memoTextController,
                    // maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: 'Memos',
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 登録ボタン
                ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () {
                    // validation
                    FormState? formKeyState = _formKey.currentState;
                    if (formKeyState != null && formKeyState.validate()) {
                      // DBへの登録
                      widget.service.putProfile(newProfile);
                      Navigator.pop(context);
                    }
                    // for debug
                    if (formKeyState == null) {
                      // print('formKey.currentState is null');
                    }
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
