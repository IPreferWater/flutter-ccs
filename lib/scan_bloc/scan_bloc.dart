import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ccs/scan_bloc/scan_event.dart';
import 'package:ccs/scan_bloc/scan_state.dart';
import 'package:ccs/services/creation_dao.dart';
import 'package:ccs/models/Creation.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  CreationDao _creationDao = CreationDao();

  // Display a loading indicator right from the start of the app
  @override
  ScanState get initialState => ScanWaiting();

  // This is where we place the logic.
  @override
  Stream<ScanState> mapEventToState(
      ScanEvent event,
      ) async* {
    if (event is ScannedCode) {

      final int qrCode = int.parse(event.qrCode);
      final creation = await _creationDao.getByQrCode(qrCode);
       yield* _getCreationByQrCode(creation);
    }
  }

  Stream <ScanState> _getCreationByQrCode(Creation creation) async* {

    if (creation == null) {
      yield ScanFinishError();
      return;
    }

    yield ScanFinishSuccess(creation);
  }
}