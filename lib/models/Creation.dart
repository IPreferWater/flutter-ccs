import 'package:ccs/models/Item.dart' as custom;

class Creation {
  custom.Item before;
  custom.Item after;
  List <custom.Item> ingredients;

  Creation({this.before, this.after, this.ingredients});

  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'before': before,
      'after': after,
      'ingredients': ingredients,
    };
  }

  @override
  String toString() {
    return 'Creation{before: $before, after: $after, imgPath: $ingredients}';
  }
}