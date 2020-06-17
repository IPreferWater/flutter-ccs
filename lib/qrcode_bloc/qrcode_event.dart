import 'package:ccs/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class QrCodeEvent extends Equatable {
  QrCodeEvent([List props = const []]) : super(props);
}

class LoadQrCodes extends QrCodeEvent {}

class LoadFreeQrCodes extends QrCodeEvent {}

class CreateQrCode extends QrCodeEvent{
  final User qrCode;

  CreateQrCode(this.qrCode) : super ([qrCode]);
}

class UpdateQrCode extends QrCodeEvent{
  final User updatedQrCode;

  UpdateQrCode(this.updatedQrCode) : super([updatedQrCode]);
}

class DeleteQrCode extends QrCodeEvent{
  final User qrCode;

  DeleteQrCode(this.qrCode) : super([qrCode]);
}