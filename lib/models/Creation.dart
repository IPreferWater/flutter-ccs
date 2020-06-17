import 'package:ccs/models/Item.dart' as custom;
import 'package:ccs/models/user.dart';
import 'package:meta/meta.dart';

class Creation {

  int id;
  String label;
  DateTime date;
  List <User> users;

  Creation({
    @required this.label,
   @required this.date,
   @required this.users});

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'date' : date,
      'users': users.map((user) => user.toMap()).toList(growable: false)
    };
  }

  static Creation fromMap(Map<String, dynamic> map) {
    var usersJson = map['users'];
    List<User> users;
    if (usersJson != null) {
      users = usersJson
          .map((user) => User.fromMap(user))
          .toList()
          .cast<User>();
    } else {
      users = [];
    }
    return Creation(
      label : map['label'],
      date : map['date'],
        users :users
    );
  }

  @override
  String toString() {
    return 'Session{ label : $label, date : $date}';
  }
}