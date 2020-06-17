import 'package:meta/meta.dart';

class User {

  int id;
  String name;
  String surname;
  bool valid;
  String code;
  String label;

  User({
   @required this.name,
   @required this.surname,
    @required this.valid,
    this.code,
    this.label
  });

  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'surname': surname,
      'valid': valid,
      'code': code,
      'label': label,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
        name : map['name'],
      surname : map['surname'],
      valid : map['valid'],
      code : map['code'],
      label : map['label'],
    );
  }

  @override
  String toString() {
    return 'User{ name : $name, surname: $surname, valid : $valid, code : $code, label : $label}';
  }
}