import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:ccs/services/creation_dao.dart';
import 'package:ccs/creation_bloc/creation_event.dart';
import 'package:ccs/creation_bloc/creation_state.dart';

import 'package:ccs/models/Creation.dart';
import 'package:ccs/models/Item.dart';


class CreationBloc extends Bloc<CreationEvent, CreationState> {
  CreationDao _creationDao = CreationDao();

  // Display a loading indicator right from the start of the app
  @override
  CreationState get initialState => CreationsLoading();


  // This is where we place the logic.
  @override
  Stream<CreationState> mapEventToState(
      CreationEvent event,
      ) async* {
    if (event is LoadCreations) {
      // Indicating that creations are being loaded - display progress indicator.
      yield CreationsLoading();
      yield* _reloadCreations();
    } else if (event is AddRandomCreation) {
      // Loading indicator shouldn't be displayed while adding/updating/deleting
      // a single Creation from the database - we aren't yielding CreationsLoading().
      print(RandomCreationGenerator.getRandomCreation());
      await _creationDao.insert(RandomCreationGenerator.getRandomCreation());
      final creations = await _creationDao.getAllSortedByName();
      print("all = $creations");
      yield* _reloadCreations();
    } else if (event is UpdateWithRandomCreation) {
      print("event is UpdateWithRandomCreation");
      final newCreation = RandomCreationGenerator.getRandomCreation();

      // Keeping the ID of the Creation the same
      newCreation.id = event.updatedCreation.id;
      await _creationDao.update(newCreation);
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
    print("event is _reloadCreations");

    final creations = await _creationDao.getAllSortedByName();
    print("fin");
    // Yielding a state bundled with the Creations from the database.
    yield CreationsLoaded(creations);
  }
}

class RandomCreationGenerator {
  static final before = Item(
      title: "beforeTitle",
      description: "before long desc",
      imgPath: "path/to/beforeImg.jpg"
  );

  static final after = Item(
      title: "afterTitle",
      description: "after long desc",
      imgPath: "path/to/beforeImg.jpg"
  );
  final creation = Creation(
      before: before,
      after: after,
      ingredients: null
  );
  static final _creations = [
    Creation(before: before, after: after, ingredients: null),
    Creation(before: before, after: after, ingredients: null),
    Creation(before: before, after: after, ingredients: null),
  ];

  static Creation getRandomCreation() {
    return _creations[Random().nextInt(_creations.length)];
  }
}