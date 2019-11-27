import 'package:ccs/models/Item.dart' as custom;
import 'package:meta/meta.dart';

class Creation {

  int id;
  custom.Item before;
  custom.Item after;
  List <custom.Item> ingredients;

  Creation({
   @required this.before,
   @required this.after,
    this.ingredients});

  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'before': before.toMap(),
      'after': after.toMap(),
      'ingredients': ingredients.map((ingredient) => ingredient.toMap()).toList(growable: false)
    };
  }

  static Creation fromMap(Map<String, dynamic> map) {

    return Creation(
      before: custom.Item.fromMap(map['before']),
      after: custom.Item.fromMap(map['after']),
      ingredients: null
    );
  }

  @override
  String toString() {
    return 'Creation{before: $before, after: $after, imgPath: $ingredients}';
  }
}