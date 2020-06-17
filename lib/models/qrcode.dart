import 'package:meta/meta.dart';

class User {

  int id;
  int serial;
  String label;

  User({
   @required this.serial,
   @required this.label
  });

  Map<String, dynamic> toMap() {
    return {
      'serial' : serial,
      'label': label
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      serial : map['serial'],
      label: map['label']
    );
  }

  @override
  String toString() {
    return 'QrCode{ serial : $serial, label: $label}';
  }
}