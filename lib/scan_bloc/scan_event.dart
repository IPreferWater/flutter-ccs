import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScanEvent extends Equatable {
  ScanEvent([List props = const []]) : super(props);
}

class ScannedCode extends ScanEvent {
  final String serial;

  ScannedCode(this.serial) : super([serial]);
}