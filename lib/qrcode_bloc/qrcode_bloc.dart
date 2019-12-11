import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ccs/models/qrcode.dart';
import 'package:ccs/qrcode_bloc/qrcode_event.dart';
import 'package:ccs/qrcode_bloc/qrcode_state.dart';
import 'package:ccs/services/qrcode_dao.dart';

class QrCodeBloc extends Bloc<QrCodeEvent, QrCodeState> {
  QrCodeDao _qrCodeDao = QrCodeDao();

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
      await _qrCodeDao.insert(event.qrCode);
      yield* _reloadQrCode();
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

    final qrCodes = await _qrCodeDao.getAllSortedById();
    //final qrCodes = List<QrCode>();
    // Yielding a state bundled with the Creations from the database.
    yield QrCodeLoaded(qrCodes);
  }
}