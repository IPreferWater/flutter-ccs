import 'package:ccs/models/Creation.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScanState extends Equatable {
  ScanState([List props = const []]) : super(props);
}

class ScanLoading extends ScanState {}

class ScanLoaded extends ScanState {
  final Creation creation;

  ScanLoaded(this.creation) : super([creation]);
}