import 'package:ccs/models/user.dart';
import 'package:ccs/services/app_database.dart';
import 'package:sembast/sembast.dart';



class QrCodeDao {
  static const String QR_CODE_STORE_NAME = 'qrcodes';
  final _qrCodeStore = intMapStoreFactory.store(QR_CODE_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(User qrCode) async {
    await _qrCodeStore.add(await _db, qrCode.toMap());
  }

  Future update(User qrCode) async {
    final finder = Finder(filter: Filter.byKey(qrCode.id));
    await _qrCodeStore.update(
      await _db,
      qrCode.toMap(),
      finder: finder,
    );
  }

  Future delete(User qrCode) async {
    final finder = Finder(filter: Filter.byKey(qrCode.id));
    await _qrCodeStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<User>> getAllSortedById() async {

    final finder = Finder(sortOrders: [
      SortOrder('id'),
    ]);

    final recordSnapshots = await _qrCodeStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final qrCode = User.fromMap(snapshot.value);
      qrCode.id = snapshot.key;
      return qrCode;
    }).toList();
  }

  Future<User> getQrCodeBySerial(int serial) async{

    final finder = Finder(filter: Filter.equals('serial', serial));

    final recordSnapshots = await _qrCodeStore.findFirst(
      await _db,
      finder:finder
    );

    if(recordSnapshots==null){
      return null;
    }

    final qrCode = User.fromMap(recordSnapshots.value);
    qrCode.id= recordSnapshots.key;
    //return QrCode.fromMap(recordSnapshots.value);
    return qrCode;
  }
}