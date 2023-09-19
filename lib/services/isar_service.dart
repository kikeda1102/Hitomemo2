import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/models/general_tag.dart';

class IsarService {
  late Future<Isar> _isar;

  IsarService() {
    _isar = openIsar();
  }

  Future<Isar> openIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [ProfileSchema, GeneralTagSchema],
      inspector: true,
      directory: dir.path,
    );
  }
  return Future.value(Isar.getInstance());
}
