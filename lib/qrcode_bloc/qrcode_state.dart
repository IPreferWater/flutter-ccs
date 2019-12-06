import 'package:ccs/models/Creation.dart';
import 'package:ccs/models/qrcode.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class QrCodeState extends Equatable {
  QrCodeState([List props = const []]) : super(props);
}

class QrCodeLoading extends QrCodeState {}

class QrCodeFinishSuccess extends QrCodeState {
  final QrCode qrCode;

  QrCodeFinishSuccess(this.qrCode) : super([qrCode]);
}
class QrCodeFinishError extends QrCodeState {}

class QrCodeLoaded extends QrCodeState {
  final List<QrCode> qrCode;

  QrCodeLoaded(this.qrCode) : super([qrCode]);
}