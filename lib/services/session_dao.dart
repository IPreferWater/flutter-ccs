import 'package:ccs/models/session.dart';
import 'package:ccs/services/app_database.dart';
import 'package:sembast/sembast.dart';



class SessionDao {
  static const String SESSION_STORE_NAME = 'sessions';
  final _sessionStore = intMapStoreFactory.store(SESSION_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Session session) async {
    final sessionMapped = session.toMap();
    return  await _sessionStore.add(await _db, sessionMapped);
  }

  Future update(Session session) async {

    final finder = Finder(filter: Filter.byKey(session.id));
    final count = await _sessionStore.update(
      await _db,
      session.toMap(),
      finder: finder,
    );

    return count;
  }

  Future delete(Session session) async {
    final finder = Finder(filter: Filter.byKey(session.id));
    await _sessionStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Session>> getAll() async {

    final recordSnapshots = await _sessionStore.find(
      await _db
    );

    final sessions = recordSnapshots.map((snapshot) {
      final session = Session.fromMap(snapshot.value);
      session.id = snapshot.key;
      return session;
    }).toList();

    return sessions;
  }

  /*Future<Session> getByQrCodeId(int qrCodeId) async {

    print("getByQrCode");

    final finder = Finder(filter: Filter.equals('qrCodeId', qrCodeId));

    final recordSnapshots = await _sessionStore.findFirst(
      await _db,
      finder: finder,
    );

    final all = await _sessionStore.find(await _db);
    print(all);

    if(recordSnapshots==null){
      return null;
    }

    return Session.fromMap(recordSnapshots.value);
  }*/
}