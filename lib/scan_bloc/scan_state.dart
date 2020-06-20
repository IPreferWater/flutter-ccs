import 'package:ccs/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScanState extends Equatable {
  ScanState([List props = const []]) : super(props);
}

class StateScanWaiting extends ScanState {}

class StateScanLoading extends ScanState {}

class StateScanFinishSuccess extends ScanState {
  final User user;

  StateScanFinishSuccess(this.user) : super([user]);
}
class StateScanFinishNotFound extends ScanState {}
