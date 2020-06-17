import 'package:ccs/models/user.dart';
import 'package:meta/meta.dart';

class Session {

  int id;
  String label;
  DateTime date;
  List <User> users;

  Session({
    @required this.label,
   @required this.date,
   @required this.users});

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'date' : date.millisecondsSinceEpoch,
      'users': users.map((user) => user.toMap()).toList(growable: false)
    };
  }

  static Session fromMap(Map<String, dynamic> map) {

    final timestamp =  map['date'];

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
    return Session(
      label : map['label'],
      date : DateTime.fromMillisecondsSinceEpoch(timestamp),
        users :users
    );
  }

  @override
  String toString() {
    return 'Session{ label : $label, date : $date}';
  }
}