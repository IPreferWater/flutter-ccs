import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScanEvent extends Equatable {
  ScanEvent([List props = const []]) : super(props);
}

class LoadCreation extends ScanEvent {}