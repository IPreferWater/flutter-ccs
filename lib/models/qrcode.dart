import 'package:meta/meta.dart';

class QrCode {

  int id;
  int serial;
  String label;

  QrCode({
   @required this.serial,
   @required this.label
  });

  Map<String, dynamic> toMap() {
    return {
      'serial' : serial,
      'label': label
    };
  }

  static QrCode fromMap(Map<String, dynamic> map) {
    return QrCode(
      serial : map['serial'],
      label: map['label']
    );
  }

  @override
  String toString() {
    return 'QrCode{ serial : $serial, label: $label}';
  }
}