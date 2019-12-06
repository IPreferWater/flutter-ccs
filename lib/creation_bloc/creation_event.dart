import 'package:ccs/models/Creation.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class CreationEvent extends Equatable {
  CreationEvent([List props = const []]) : super(props);
}

class LoadCreations extends CreationEvent {}

class AddRandomCreation extends CreationEvent {}

class UpdateCreation extends CreationEvent {
  final Creation updatedCreation;

  UpdateCreation(this.updatedCreation) : super([updatedCreation]);
}

class CreateCreation extends CreationEvent{
  final Creation creation;

  CreateCreation(this.creation) : super ([creation]);
}

class DeleteCreation extends CreationEvent {
  final Creation creation;

  DeleteCreation(this.creation) : super([creation]);
}