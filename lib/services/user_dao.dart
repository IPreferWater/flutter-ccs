import 'package:ccs/models/user.dart';
import 'package:ccs/services/app_database.dart';
import 'package:sembast/sembast.dart';



class UserDao {
  static const String USER_STORE_NAME = 'users';
  final _userStore = intMapStoreFactory.store(USER_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(User user) async {
    await _userStore.add(await _db, user.toMap());
  }

  Future update(User user) async {
    final finder = Finder(filter: Filter.byKey(user.id));
    await _userStore.update(
      await _db,
      user.toMap(),
      finder: finder,
    );
  }

  Future delete(User user) async {
    final finder = Finder(filter: Filter.byKey(user.id));
    await _userStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<User>> getAllSortedById() async {

    final finder = Finder(sortOrders: [
      SortOrder('id'),
    ]);

    final recordSnapshots = await _userStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final user = User.fromMap(snapshot.value);
      user.id = snapshot.key;
      return user;
    }).toList();
  }

  Future<User> getUserByCode(String code) async{

    final finder = Finder(filter: Filter.equals('code', code));

    final recordSnapshots = await _userStore.findFirst(
      await _db,
      finder:finder
    );

    if(recordSnapshots==null){
      return null;
    }

    final user = User.fromMap(recordSnapshots.value);
    user.id= recordSnapshots.key;
    return user;
  }
}