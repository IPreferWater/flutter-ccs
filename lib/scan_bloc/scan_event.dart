import 'package:ccs/models/session.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScanEvent extends Equatable {
  ScanEvent([List props = const []]) : super(props);
}

class EventScannedCode extends ScanEvent {
  final String code;

  EventScannedCode(this.code) : super([code]);

}

class EventUserScanAndInsertInSession extends ScanEvent {
  final String code;
  final Session session;

  EventUserScanAndInsertInSession(this.code, this.session) : super([code]);

}