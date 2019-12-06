import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ccs/models/qrcode.dart';
import 'package:ccs/qrcode_bloc/bloc.dart' as prefix0;
import 'package:ccs/qrcode_bloc/qrcode_event.dart';
import 'package:ccs/qrcode_bloc/qrcode_state.dart';
import 'package:ccs/scan_bloc/scan_event.dart';
import 'package:ccs/scan_bloc/scan_state.dart';
import 'package:ccs/services/creation_dao.dart';
import 'package:ccs/models/Creation.dart';

class QrCodeBloc extends Bloc<QrCodeEvent, QrCodeState> {
  CreationDao _creationDao = CreationDao();

  // Display a loading indicator right from the start of the app
  @override
  QrCodeState get initialState => QrCodeLoading();

  // This is where we place the logic.
  @override
  Stream<QrCodeState> mapEventToState(
      QrCodeEvent event,
      ) async* {
    if (event is LoadQrCodes) {
      yield QrCodeLoading();
      yield* _reloadQrCode();
    }

    else if (event is CreateQrCode){
      //todo
    }

    else if (event is UpdateQrCode){
      //todo
    }

    else if (event is DeleteQrCode){
      //todo
    }
  }

  Stream<QrCodeState> _reloadQrCode() async* {
    print("event is _reloadCreations");

    //final qrCodes = await _creationDao.getAllSortedByName();
    final qrCodes = List<QrCode>();
    // Yielding a state bundled with the Creations from the database.
    yield QrCodeLoaded(qrCodes);
  }
}