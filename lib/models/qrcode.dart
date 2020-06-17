import 'package:meta/meta.dart';

class User {

  int id;
  String code;
  String label;

  User({
   @required this.code,
   @required this.label
  });

  Map<String, dynamic> toMap() {
    return {
      'serial' : code,
      'label': label
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      code : map['serial'],
      label: map['label']
    );
  }

  @override
  String toString() {
    return 'QrCode{ serial : $code, label: $label}';
  }
}