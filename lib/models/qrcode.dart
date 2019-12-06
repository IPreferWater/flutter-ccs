import 'package:meta/meta.dart';

class QrCode {

  int id;
  int qrCode;
  String label;

  QrCode({
   @required this.qrCode,
   @required this.label
  });

  Map<String, dynamic> toMap() {
    return {
      'qrCode' : qrCode,
      'label': label
    };
  }

  static QrCode fromMap(Map<String, dynamic> map) {

    return QrCode(
      qrCode : map['qrCode'],
      label: map['label']
    );
  }

  @override
  String toString() {
    return 'QrCode{ qrCode : $qrCode, label: $label}';
  }
}