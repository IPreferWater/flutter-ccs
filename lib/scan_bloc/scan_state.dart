import 'package:ccs/models/Creation.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScanState extends Equatable {
  ScanState([List props = const []]) : super(props);
}

class ScanWaiting extends ScanState {}

class ScanLoading extends ScanState {}

class ScanFinishSuccess extends ScanState {
  final Session creation;

  ScanFinishSuccess(this.creation) : super([creation]);
}
class ScanFinishNotFound extends ScanState {}

class ScanLoaded extends ScanState {
  final Session creation;

  ScanLoaded(this.creation) : super([creation]);
}