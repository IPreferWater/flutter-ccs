import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ccs/services/session_dao.dart';
import 'package:ccs/creation_bloc/creation_event.dart';
import 'package:ccs/creation_bloc/creation_state.dart';

class CreationBloc extends Bloc<CreationEvent, CreationState> {
  SessionDao _creationDao = SessionDao();

  @override
  CreationState get initialState => CreationsLoading();

  @override
  Stream<CreationState> mapEventToState(
      CreationEvent event,
      ) async* {
    if (event is LoadCreations) {
      yield CreationsLoading();
      yield* _reloadCreations();
    } else if (event is UpdateCreation) {
      await _creationDao.update(event.updatedCreation);
      yield* _reloadCreations();

    } else if (event is DeleteCreation) {
      await _creationDao.delete(event.creation);
      yield* _reloadCreations();
    } else if (event is CreateCreation){

      await _creationDao.insert(event.creation);
      yield* _reloadCreations();
    }
  }

  Stream<CreationState> _reloadCreations() async* {
    final creations = await _creationDao.getAll();
    // Yielding a state bundled with the Creations from the database.
    yield CreationsLoaded(creations);
  }
}