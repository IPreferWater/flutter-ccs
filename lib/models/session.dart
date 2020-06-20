import 'package:ccs/models/user.dart';
import 'package:meta/meta.dart';

class Session {

  int id;
  String label;
  DateTime date;
  List <int> usersID;

  Session({
    @required this.label,
   @required this.date,
   @required this.usersID});

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'date' : date.millisecondsSinceEpoch,
      'users': usersID.map((id) => id).toList(growable: false)
    };
  }

  static Session fromMap(Map<String, dynamic> map) {

    final timestamp =  map['date'];

    var usersJson = map['users'];
    List<int> usersID;
    if (usersJson != null) {
      usersID = usersJson
          .map((user) =>user)
          .toList()
          .cast<int>();
    } else {
      usersID = [];
    }
    return Session(
      label : map['label'],
      date : DateTime.fromMillisecondsSinceEpoch(timestamp),
        usersID :usersID
    );
  }

  @override
  String toString() {
    return 'Session{ label : $label, date : $date}';
  }
}