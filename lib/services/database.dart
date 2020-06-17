import 'dart:async';

import 'package:ccs/models/session.dart';
//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:sembast/sembast.dart';
//import 'package:sembast/sembast_io.dart';

Future<void> insertDog(Session creation) async {

 // Database db = await databaseFactoryIo
  //    .openDatabase(join(".dart_tool", "sembast", "example", "record_demo.db"));



  /*final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'ccs_database.db'),
    version: 1,
  );*/

 // Database db = await createDatabaseFactoryIo.openDatabase
  //var store = intMapStoreFactory.store("my_store");


/*  // Get a reference to the database.
  final Database db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'creation',
    creation.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  print("creation inserted");*/
}

// A method that retrieves all the dogs from the dogs table.
//Future<List<Dog>> dogs() async {
/*
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'doggie_database.db'),
    version: 1,
  );

  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('dogs');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return Dog(
      id: maps[i]['id'],
      name: maps[i]['name'],
      age: maps[i]['age'],
    );
  });*/
//}

Future<void> updateDog(Dog dog) async {
/*
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'doggie_database.db'),
    version: 1,
  );
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db.update(
    'dogs',
    dog.toMap(),
    // Ensure that the Dog has a matching id.
    where: "id = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [dog.id],
  );*/
}

Future<void> deleteDog(int id) async {
/*
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'doggie_database.db'),
    version: 1,
  );
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the Database.
  await db.delete(
    'dogs',
    // Use a `where` clause to delete a specific dog.
    where: "id = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );*/
}


// Update the Dog class to include a `toMap` method.
class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}