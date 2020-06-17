import 'dart:io';

import 'package:before_after/before_after.dart';
import 'package:ccs/scan_bloc/bloc.dart';
import 'package:ccs/screens/admin.dart';
import 'package:ccs/widgets/scan_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   ScanBloc _scanBloc;

  @override
  void initState() {
    super.initState();
    _scanBloc = BlocProvider.of<ScanBloc>(context);

    //_scanBloc.dispatch(ScanWaiting());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Before After'), centerTitle: true),
      body: Center(
        child: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
          _beforeAfterWidget(),
         // ScanScreen(),
          ScanWidget(
            context: context,
            scanBloc: _scanBloc,
          ),
          RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              splashColor: Colors.blueGrey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminScreen()),
                );
              },
              child: const Text('admin')),
        ]),
      ),
    );
  }

   Widget _beforeAfterWidget(){
     return BlocBuilder(
         bloc: _scanBloc,
             builder: (BuildContext context, ScanState state){
               if (state is ScanWaiting){
                 return Text(
                   "let's scan !",
                 );
               }

           if (state is ScanLoading){
             return Center(
               child: CircularProgressIndicator(),
             );
           }

           if(state is ScanFinishSuccess){
             //final beforeImage = new File(state.creation.before.imgPath);
             //final afterImage = new File(state.creation.after.imgPath);

             /*return BeforeAfter(
               beforeImage: Image.file( beforeImage),
               afterImage: Image.file( afterImage),
                 imageCornerRadius: 10,
             );*/
           }

           if(state is ScanFinishNotFound){
             return Text("can't find this code");
           }
           return Text("error");
     },
     );
   }
}
/*
class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
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
      this.widget.
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
*/