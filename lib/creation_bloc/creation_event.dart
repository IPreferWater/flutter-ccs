import 'package:ccs/models/Creation.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class CreationEvent extends Equatable {
  CreationEvent([List props = const []]) : super(props);
}

class LoadCreations extends CreationEvent {}

class CreateCreation extends CreationEvent{
  final Session creation;

  CreateCreation(this.creation) : super ([creation]);
}

class UpdateCreation extends CreationEvent {
  final Session updatedCreation;

  UpdateCreation(this.updatedCreation) : super([updatedCreation]);
}

class DeleteCreation extends CreationEvent {
  final Session creation;

  DeleteCreation(this.creation) : super([creation]);
}