
class Item {
   String title;
   String description;
   String imgPath;

  Item({this.title, this.description, this.imgPath});

  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imgPath': imgPath,
    };
  }

   static Item fromMap(Map<String, dynamic> map) {
     return Item(
         title: map['title'],
         description: map['description'],
         imgPath: map['imgPath']
     );
   }

  @override
  String toString() {
    return 'Item{title: $title, description: $description, imgPath: $imgPath}';
  }
}