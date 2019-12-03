import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:ccs/scan_bloc/scan_event.dart';
import 'package:ccs/scan_bloc/scan_state.dart';
import 'package:ccs/services/creation_dao.dart';

import 'package:ccs/models/Creation.dart';
import 'package:ccs/models/Item.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  CreationDao _creationDao = CreationDao();

  // Display a loading indicator right from the start of the app
  @override
  ScanState get initialState => ScanLoading();


  // This is where we place the logic.
  @override
  Stream<ScanState> mapEventToState(
      ScanEvent event,
      ) async* {
    if (event is ScannedCode) {

     Creation creationToLoad = await _getCreationByQrCode(event.qrCode);
      // Indicating that creations are being loaded - display progress indicator.
     // yield CreationsLoading();
     // yield* _reloadCreations();
    }
  }

  Future<Creation> _getCreationByQrCode(String qrCode) async {
    print("we should load the just scanned item");

    final creation = await _creationDao.getByQrCode("1");
    if(creation != null){
      return creation;
    }
    return null;
    //yield CreationsLoaded(creations);
  }
}