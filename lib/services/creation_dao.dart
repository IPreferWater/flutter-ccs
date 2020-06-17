import 'package:ccs/models/session.dart';
import 'package:ccs/services/app_database.dart';
import 'package:sembast/sembast.dart';



class CreationDao {
  static const String CREATION_STORE_NAME = 'creations';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Creation objects converted to Map
  final _creationStore = intMapStoreFactory.store(CREATION_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Session creation) async {
    final creationMapped = creation.toMap();
    return  await _creationStore.add(await _db, creationMapped);
  }

  Future update(Session creation) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(creation.id));
    await _creationStore.update(
      await _db,
      creation.toMap(),
      finder: finder,
    );
  }

  Future delete(Session creation) async {
    final finder = Finder(filter: Filter.byKey(creation.id));
    await _creationStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Session>> getAll() async {

    final recordSnapshots = await _creationStore.find(
      await _db
    );

    final sessions = recordSnapshots.map((snapshot) {
      final creation = Session.fromMap(snapshot.value);
      creation.id = snapshot.key;
      return creation;
    }).toList();

    return sessions;
  }

  Future<Session> getByQrCodeId(int qrCodeId) async {

    print("getByQrCode");

    final finder = Finder(filter: Filter.equals('qrCodeId', qrCodeId));

    final recordSnapshots = await _creationStore.findFirst(
      await _db,
      finder: finder,
    );

    final all = await _creationStore.find(await _db);
    print(all);

    if(recordSnapshots==null){
      return null;
    }

    return Session.fromMap(recordSnapshots.value);
  }
}