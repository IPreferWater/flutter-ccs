import 'package:ccs/models/Creation.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class CreationState extends Equatable {
  CreationState([List props = const []]) : super(props);
}

class CreationsLoading extends CreationState {}

class CreationsLoaded extends CreationState {
  final List<Creation> creations;

  CreationsLoaded(this.creations) : super([creations]);
}