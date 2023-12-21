import 'package:flutter/material.dart';
import 'package:hito_memo_2/services/isar_service.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hito_memo_2/components/edit_profile_widget.dart';

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
      body: EditProfileWidget(
        profile: newProfile,
        formKey: _formKey,
        memoTextController: _memoTextController,
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
}
