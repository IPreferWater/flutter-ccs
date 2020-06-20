import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ccs/scan_bloc/scan_event.dart';
import 'package:ccs/scan_bloc/scan_state.dart';
import 'package:ccs/services/session_dao.dart';
import 'package:ccs/services/user_dao.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {

  UserDao _userDao = UserDao();
  SessionDao _sessionDao = SessionDao();

  @override
  ScanState get initialState => StateScanWaiting();

  @override
  Stream<ScanState> mapEventToState(
      ScanEvent event,
      ) async* {

    yield StateScanLoading();

    if (event is EventScannedCode) {

      final user = await _userDao.getUserByCode(event.code);
      if(user==null){
        yield StateScanFinishNotFound();
        return;
      }

      yield StateScanFinishSuccess(user);
    }

    else if (event is EventUserScanAndInsertInSession) {
      final user = await _userDao.getUserByCode(event.code);
      if(user==null){
        yield StateScanFinishNotFound();
        return;
      }

      if (event.session.usersID.contains(user.id)){
        yield StateScanFinishUserAlreadyAdded(user);
        return;
      }

      event.session.usersID.add(user.id);

      final countResponse = await _sessionDao.update(event.session);

      if (countResponse != 1 ) {
        yield StateScanFinishErrorDatabase();
        return;
      }

      yield StateScanFinishSuccess(user);
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