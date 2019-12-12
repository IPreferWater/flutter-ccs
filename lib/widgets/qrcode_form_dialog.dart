import 'package:barcode_scan/barcode_scan.dart';
import 'package:ccs/models/qrcode.dart';
import 'package:ccs/qrcode_bloc/bloc.dart';
import 'package:ccs/qrcode_bloc/qrcode_bloc.dart';
import 'package:ccs/scan_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class QrCodeFormDialog extends StatefulWidget{

  //final BuildContext context;
  final QrCodeBloc qrCodeBloc;
  final QrCode qrCodeToUpdate;

  QrCodeFormDialog({
    //@required this.context,
    @required this.qrCodeBloc,
    this.qrCodeToUpdate

  });

  _QrCodeFormDialogState createState() => _QrCodeFormDialogState();


}
class _QrCodeFormDialogState extends State<QrCodeFormDialog> {

  ScanBloc _scanBloc;
  final _formKey = GlobalKey<FormState>();
  final qrCodeInput = TextEditingController();
  final label = TextEditingController();
  /*final beforeTitle = TextEditingController();
  final beforeDescription = TextEditingController();
  final beforeImageUrl = TextEditingController();

  final afterTitle = TextEditingController();
  final afterDescription = TextEditingController();
  final afterImageUrl = TextEditingController();

  int qrCode;*/

  @override
  void initState(){
    super.initState();

    _scanBloc = BlocProvider.of<ScanBloc>(context);

    if(this.widget.qrCodeToUpdate!=null){
     /* final Creation creationToUpdate = widget.qrCodeToUpdate;
      qrCode = creationToUpdate.qrCode;

      beforeTitle.text = creationToUpdate.before.title;
      beforeDescription.text = creationToUpdate.before.description;
      beforeImageUrl.text = creationToUpdate.before.imgPath;

      afterTitle.text = creationToUpdate.after.title;
      afterDescription.text = creationToUpdate.after.description;
      afterImageUrl.text = creationToUpdate.after.imgPath;*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Dialog(
      elevation: 0.0,
      child: dialogContent(context),
    );
  }

  Widget _buildQrCodeFormField(){
    return BlocBuilder(
      bloc: _scanBloc,
      builder: (BuildContext context, ScanState state){
        if (state is ScanWaiting){
         return RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              splashColor: Colors.blueGrey,
              onPressed: scan,
              child: const Text('START CAMERA SCAN')
          );
        }

        if (state is ScanLoading){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if(state is ScanFinishSuccess){
          return Text(
            "done",
          );
        }

        if(state is ScanFinishError){
          return Text("can't find this code");
        }
        return Text("error");
      },
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.qrCodeInput.text = barcode);
      _scanBloc.dispatch(ScannedCode(barcode));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
          //snack error 'The user did not grant the camera permission!';
      } else {
        //snack error 'Unknown error: $e');
      }
    } on FormatException {/*
      setState(() => this.barcode =
      'null (User returned using the "back"-button before scanning anything. Result)');*/
    } catch (e) {/*
      setState(() => this.barcode = 'Unknown error: $e');*/
    }
  }

  dialogContent(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              _buildQrCodeFormField(),
              TextFormField(
                controller: qrCodeInput,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  icon: Icon(Icons.pages),
                  hintText: 'tape manually the code',
                  labelText: 'qr code',
                ),
                validator: (String value) {
                  return value.isEmpty ? 'must not be empty' : null;
                },
              ),
              TextFormField(
                controller: label,
                decoration: const InputDecoration(
                  icon: Icon(Icons.label),
                  hintText: 'label to display for this code',
                  labelText: 'label',
                ),
                validator: (String value) {
                  return value.isEmpty ? 'must not be empty' : null;
                },
              ),
              Column(
                children: <Widget>[
                 /* RaisedButton(
                    onPressed: (){
                      getImageFromCamera();
                    },
                    child: Text('camera'),
                  ),*/
                ],
              ),

              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                       /* final before = Item(
                            title: beforeTitle.text,
                            description: beforeDescription.text,
                            imgPath: beforeImageUrl.text
                        );*/

                        final qrCodeInt = int.parse(qrCodeInput.text);

                       final qrCodeToCreate = QrCode(qrCode: qrCodeInt, label: label.text);

                       widget.qrCodeBloc.dispatch(CreateQrCode(qrCodeToCreate));

                        //TODO: make this code correct
                        /*if(widget.qrCodeToUpdate!=null){
                          creationToCreate.id = widget.qrCodeToUpdate.id;
                          widget.qrCodeBloc.dispatch(UpdateCreation(creationToCreate));
                        }else{
                          widget.qrCodeBloc.dispatch(CreateCreation(creationToCreate));
                        }*/



                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Submit'),
                  )),
            ]
        )
    );
  }

}
