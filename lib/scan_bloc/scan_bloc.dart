import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ccs/scan_bloc/scan_event.dart';
import 'package:ccs/scan_bloc/scan_state.dart';
import 'package:ccs/services/user_dao.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {

  UserDao _userDao = UserDao();

  @override
  ScanState get initialState => StateScanWaiting();

  @override
  Stream<ScanState> mapEventToState(
      ScanEvent event,
      ) async* {
    if (event is EventScannedCode) {

      final user = await _userDao.getUserByCode(event.code);
      if(user==null){
        yield StateScanFinishNotFound();
      }

      yield StateScanFinishSuccess(user);
    }

    else if (event is EventUserScanAndInsertInSession) {
      final user = await _userDao.getUserByCode(event.code);
      if(user==null){
        yield StateScanFinishNotFound();
      }


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