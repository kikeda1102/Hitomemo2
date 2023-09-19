import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hito_memo_2/models/profile.dart';
import 'package:hito_memo_2/models/general_tag.dart';

// DBを操作するためのserviceクラス
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
