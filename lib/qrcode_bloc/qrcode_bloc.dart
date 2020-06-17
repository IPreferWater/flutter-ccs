import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ccs/models/user.dart';
import 'package:ccs/qrcode_bloc/qrcode_event.dart';
import 'package:ccs/qrcode_bloc/qrcode_state.dart';
import 'package:ccs/services/creation_dao.dart';
import 'package:ccs/services/qrcode_dao.dart';

class QrCodeBloc extends Bloc<QrCodeEvent, QrCodeState> {
  QrCodeDao _qrCodeDao = QrCodeDao();
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

    else if (event is LoadFreeQrCodes){
      yield QrCodeLoading();
      yield* _reloadFreeQrCode();
    }

    else if (event is CreateQrCode){
      await _qrCodeDao.insert(event.qrCode);
      yield* _reloadQrCode();
    }

    else if (event is UpdateQrCode){
      await _qrCodeDao.update(event.updatedQrCode);
      yield* _reloadQrCode();
    }

    else if (event is DeleteQrCode){
      await _qrCodeDao.delete(event.qrCode);
      yield* _reloadQrCode();
    }
  }

  Stream<QrCodeState> _reloadQrCode() async* {
    final qrCodes = await _qrCodeDao.getAllSortedById();
    print(qrCodes);
    yield QrCodeLoaded(qrCodes);
  }

  Stream<QrCodeState> _reloadFreeQrCode() async* {
    var qrCodes = await _qrCodeDao.getAllSortedById();
    final creations = await _creationDao.getAll();

    final alreadyUsedQrCode = creations.map((creation) => creation.qrCodeId).toList();

    qrCodes.removeWhere((qrCode) =>
      alreadyUsedQrCode.contains(qrCode.id)
    );


    yield QrCodeLoaded(qrCodes);
  }
}