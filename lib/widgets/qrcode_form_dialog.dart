import 'package:ccs/models/qrcode.dart';
import 'package:ccs/qrcode_bloc/bloc.dart';
import 'package:ccs/qrcode_bloc/qrcode_bloc.dart';
import 'package:flutter/material.dart';

class QrCodeFormDialog extends StatefulWidget{

  final BuildContext context;
  final QrCodeBloc qrCodeBloc;
  final QrCode qrCodeToUpdate;

  QrCodeFormDialog({
    @required this.context,
    @required this.qrCodeBloc,
    this.qrCodeToUpdate

  });

  _QrCodeFormDialogState createState() => _QrCodeFormDialogState();


}
class _QrCodeFormDialogState extends State<QrCodeFormDialog> {

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

  dialogContent(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
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
