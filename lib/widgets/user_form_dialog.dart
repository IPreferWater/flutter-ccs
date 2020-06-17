import 'package:barcode_scan/barcode_scan.dart';
import 'package:ccs/models/user.dart';
import 'package:ccs/qrcode_bloc/bloc.dart';
import 'package:ccs/qrcode_bloc/qrcode_bloc.dart';
import 'package:ccs/scan_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class UserFormDialog extends StatefulWidget{

  final User userToUpdate;

  UserFormDialog({
    this.userToUpdate
  });

  _UserFormDialogState createState() => _UserFormDialogState();


}
class _UserFormDialogState extends State<UserFormDialog> {

  ScanBloc _scanBloc;
  QrCodeBloc _qrCodeBloc;

  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final surname = TextEditingController();
  final qrCodeInput = TextEditingController();
  final label = TextEditingController();
  bool valid = false;

  @override
  void initState(){
    super.initState();

    _scanBloc = BlocProvider.of<ScanBloc>(context);
    _qrCodeBloc = BlocProvider.of<QrCodeBloc>(context);

    if(this.widget.userToUpdate!=null){
      final User user = widget.userToUpdate;
      name.text = user.name.toString();
      surname.text = user.surname.toString();
      valid = user.valid;
      qrCodeInput.text = user.code.toString();
      label.text = user.label;
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

  Widget _scanButton(){
    return RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        splashColor: Colors.blueGrey,
        onPressed: scan,
        child: const Text('START CAMERA SCAN')
    );
  }

  Widget _buildQrCodeFormField(){
    return BlocBuilder(
      bloc: _scanBloc,
      builder: (BuildContext context, ScanState state){
        if (state is ScanWaiting){
         return _scanButton();
        }

        if (state is ScanLoading){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if(state is ScanFinishSuccess){
          return
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("the code scanned is already taken",)
                ),
                Expanded(child: _scanButton()),
              ],
            );
        }

        if(state is ScanFinishNotFound){
          return             Row(
            children: <Widget>[
              Expanded(
                  child: Text("the code scanned is free",)
              ),
              Expanded(child: _scanButton()),
            ],
          );
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
                controller: name,
                decoration: const InputDecoration(
                  icon: Icon(Icons.pages),
                  hintText: 'name',
                  labelText: 'name',
                ),
                validator: (String value) {
                  return value.isEmpty ? 'must not be empty' : null;
                },
              ),
              TextFormField(
                controller: surname,
                decoration: const InputDecoration(
                  icon: Icon(Icons.pages),
                  hintText: 'surname',
                  labelText: 'surname',
                ),
                validator: (String value) {
                  return value.isEmpty ? 'must not be empty' : null;
                },
              ),
              Switch(
                value: valid,
                onChanged: (value) {
                  setState(() {
                    valid = value;
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              TextFormField(
                controller: qrCodeInput,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  icon: Icon(Icons.pages),
                  hintText: 'tape manually the code',
                  labelText: 'qr code',
                ),
                validator: (String value) {
                 // return value.isEmpty ? 'must not be empty' : null;
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
                //  return value.isEmpty ? 'must not be empty' : null;
                },
              ),

              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {


                       final qrCodeToCreate = User(
                           name: name.text,
                           surname: surname.text,
                           valid: valid,
                           code: qrCodeInput.text,
                           label: label.text);


                        //TODO: make this code correct
                        if(widget.userToUpdate!=null){
                          qrCodeToCreate.id = widget.userToUpdate.id;
                          _qrCodeBloc.dispatch(UpdateQrCode(qrCodeToCreate));
                        }else{
                          _qrCodeBloc.dispatch(CreateQrCode(qrCodeToCreate));
                        }



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
