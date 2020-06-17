import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ccs/models/user.dart';
import 'package:ccs/scan_bloc/scan_event.dart';
import 'package:ccs/scan_bloc/scan_state.dart';
import 'package:ccs/services/creation_dao.dart';
import 'package:ccs/models/session.dart';
import 'package:ccs/services/qrcode_dao.dart';
import 'package:flutter/cupertino.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  CreationDao _creationDao = CreationDao();
  QrCodeDao _qrCodeDao = QrCodeDao();

  // Display a loading indicator right from the start of the app
  @override
  ScanState get initialState => ScanWaiting();

  // This is where we place the logic.
  @override
  Stream<ScanState> mapEventToState(
      ScanEvent event,
      ) async* {
    if (event is ScannedCode) {

      final int serial = int.parse(event.serial);
      final qrCode = await _qrCodeDao.getQrCodeBySerial(serial);
      if(qrCode==null){
        yield ScanFinishNotFound();
      }

      final creation = await _creationDao.getByQrCodeId(qrCode.id);

      if (creation == null) {
        yield ScanFinishNotFound();
        return;
      }

      yield ScanFinishSuccess(creation);
    }
    }
  }

 /* Stream <ScanState> _getCreationByQrCode(Creation creation) async* {

    if (creation == null) {
      yield ScanFinishNotFound();
      return;
    }

    yield ScanFinishSuccess(creation);
  }
}*/