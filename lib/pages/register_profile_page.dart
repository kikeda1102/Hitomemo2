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
  // 新規Profile
  Profile newProfile = Profile(
    name: '',
    imageBytes: null,
    personalTags: List<String>.empty(growable: true),
    memo: '',
  );

  // 名前を入力するTextField
  final _nameTextController = TextEditingController();
  // メモを入力するTextField
  final _memoTextController = TextEditingController();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                // 名前を入力するTextField
                Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextFormField(
                    controller: _nameTextController,
                    decoration: const InputDecoration(
                      // labelText: 'Name',
                      hintText: 'Enter the name',
                    ),
                    onChanged: (text) {
                      newProfile = newProfile.copyWith(name: text);
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
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
