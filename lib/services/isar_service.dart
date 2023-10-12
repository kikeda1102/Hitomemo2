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
        [ProfileSchema],
        inspector: true,
        directory: dir.path,
      );
    }
    // すでにIsarのインスタンスがあればそれを返す
    return Future.value(Isar.getInstance());
  }

  // CRUD操作
  // profileのメンバ変数を変更する操作は、profile.dartでcopyWith()として定義されている(DB操作ではない)

  // put (更新)
  Future<void> putProfile(Profile newProfile) async {
    final isar = await _isar;
    isar.writeTxn(() async {
      isar.profiles.put(newProfile);
    });
  }

  // putSync
  Future<void> putSyncProfile(Profile newProfile) async {
    final isar = await _isar;
    isar.writeTxnSync<int>(() => isar.profiles.putSync(newProfile));
  }

  // Read
  // 全件をStreamとして取得
  Stream<List<Profile>> listenToAllProfiles() async* {
    final isar = await _isar;
    yield* isar.profiles.where().watch(
          fireImmediately: true,
        ); // 初回の要素リストを最初に返す
  }

  // idで1件をStreamとして取得
  Stream<Profile> listenToProfile(int id) async* {
    final isar = await _isar;
    Stream<Profile?> stream = isar.profiles.watchObject(
      id,
      fireImmediately: true,
    );
    // nullの場合に対応
    Stream<Profile> nonNullableStream = stream
        .where((profile) => profile != null) // nullでない要素だけをフィルタリング
        .map((profile) {
      if (profile == null) {
        throw Exception("Null profile encountered."); // エラーをスロー
      }
      return profile; // nullでない場合、profileを返す
    });
    yield* nonNullableStream;
  }

  // 全件をListとして取得
  // addボタンが押された時のorderRefresh()で使用
  Future<List<Profile>> getAllProfiles() async {
    final isar = await _isar;
    return isar.profiles.where().findAll();
  }

  // 取得する件数を指定してランダムに取得
  // memoを持たないprofileは除外する
  Future<List<Profile>> getProfilesRomdomly(int number) async {
    final isar = await _isar;
    // ランダムに取得する
    return isar.profiles.where().findAll().then((value) {
      // memoを持たないprofileを除外
      value = value.where((profile) => profile.memos.isNotEmpty).toList();
      // 取得した要素をシャッフル
      value.shuffle();
      // numberがprofilesの長さより大きい時は、profilesの長さで返す
      if (number > value.length) {
        number = value.length;
      }
      // 先頭からnumber個を返す
      return value.sublist(0, number);
    });
  }

  // Delete
  Future<void> deleteProfile(int id) async {
    final isar = await _isar;
    await isar.writeTxn(() => isar.profiles.delete(id));
  }
}
