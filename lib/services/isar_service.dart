import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hito_memo_2/models/profile.dart';
// import 'package:hito_memo_2/models/general_tag.dart';

// IsarServcie: DBを操作するためのメソッドを持つserviceクラス
class IsarService {
  late Future<Isar> _isar; // Isarのインスタンスを格納するメンバ変数

  IsarService() {
    _isar = openIsar();
  }

  // クラスメソッド
  // Isarのインスタンスを作成
  Future<Isar> openIsar() async {
    // Isarのインスタンスがなければ作成
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        // [ProfileSchema, GeneralTagSchema], // TODO: GeneralTagの実装
        [ProfileSchema],
        inspector: true,
        directory: dir.path,
      );
    }
    // すでにIsarのインスタンスがあればそれを返す
    return Future.value(Isar.getInstance());
  }

  // CRUD操作
  // プロパティの一部を更新する操作はcopyWithとしてprofile.dartで定義されている(copyWithはDB操作ではない)
// put (更新)
  Future<void> putProfile(Profile newProfile) async {
    final isar = await _isar;
    isar.writeTxn(() async {
      isar.profiles.put(newProfile);
    });
  }

  // Read
  // 全件取得
  Stream<List<Profile>> listenToAllProfiles() async* {
    final isar = await _isar;
    yield* isar.profiles.where().watch(fireImmediately: true); // 初回の要素リストを最初に返す
  }

  // idで取得
  Stream<Profile?> listenToProfile(int id) async* {
    final isar = await _isar;
    yield* isar.profiles.watchObject(
        id); // watchObjectのAPI仕様: https://pub.dev/documentation/isar/latest/isar/IsarCollection/watchObject.html
  }

  // Delete
  Future<void> deleteProfile(int id) async {
    final isar = await _isar;
    await isar.writeTxn(() => isar.profiles.delete(id));
  }
}
