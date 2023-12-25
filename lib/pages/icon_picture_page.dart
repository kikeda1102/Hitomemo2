import 'package:flutter/material.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/components/score_icon.dart';

class IconPicturePage extends StatelessWidget {
  const IconPicturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Profile profile = Profile(
      name: 'a',
      imageBytes: null,
      memos: List<String>.empty(),
      numberOfIncorrectTaps: 0,
    );
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: scoreIcon(profile, 220),
          ),
        ),
      ),
    );
  }
}
