import 'package:ccs/models/session.dart';
import 'package:ccs/scan_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class ScanWidget extends StatefulWidget {

  final BuildContext context;
  final ScanBloc scanBloc;
  final Session session;

  ScanWidget({
    @required this.context,
    @required this.scanBloc,
    @required this.session,
  });

  _ScanWidgetState createState() => new _ScanWidgetState();
}

class _ScanWidgetState extends State<ScanWidget> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: scan,
                  child: const Text('START CAMERA SCAN')
              ),
              Text(
                barcode,
                textAlign: TextAlign.center,
              )
            ]
        )
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      widget.scanBloc.dispatch(EventUserScanAndInsertInSession(barcode, widget.session));
    } on PlatformException catch (e) {
    if (e.code == BarcodeScanner.CameraAccessDenied) {
    setState(() {
    this.barcode = 'The user did not grant the camera permission!';
    });
    } else {
    setState(() => this.barcode = 'Unknown error: $e');
    }
    } on FormatException {
    setState(() => this.barcode =
    'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
    setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}