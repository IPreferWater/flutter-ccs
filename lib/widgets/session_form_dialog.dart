import 'package:ccs/creation_bloc/bloc.dart';
import 'package:ccs/creation_bloc/creation_bloc.dart';
import 'package:ccs/models/user.dart';
import 'package:ccs/qrcode_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../models/session.dart';
import '../models/Item.dart';
import 'dropdown_formfield.dart';

class SessionFormDialog extends StatefulWidget{

  final Session sessionToUpdate;

  SessionFormDialog({
    this.sessionToUpdate
  });

  _SessionFormDialogState createState() => _SessionFormDialogState();

}
class _SessionFormDialogState extends State<SessionFormDialog> {

  CreationBloc _creationBloc;
  QrCodeBloc _qrCodeBloc;

  final _formKey = GlobalKey<FormState>();
  final label = TextEditingController();
  DateTime date = DateTime.now();

  @override
  void initState(){
    super.initState();

    _creationBloc = BlocProvider.of<CreationBloc>(context);
    _creationBloc.dispatch(LoadCreations());


    _qrCodeBloc = BlocProvider.of<QrCodeBloc>(context);
    //we load only the free qrCode
    //_qrCodeBloc.dispatch(LoadFreeQrCodes());

    if(this.widget.sessionToUpdate!=null){
      final Session session = widget.sessionToUpdate;
     /* qrCodeId = creationToUpdate.qrCodeId;

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
              _buildQrCodeDropDown(),
              TextFormField(
                controller: label,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'label of session',
                  labelText: 'label',
                ),
                validator: (String value) {
                  return value.isEmpty ? 'must not be empty' : null;
                },
              ),
              Text(date.toString()),
              RaisedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select date'),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {

                        final sessionToCreate = Session(
                         label: label.text,
                          date: date,
                          users: <User>[]
                        );

                        //TODO: make this code correct
                        if(widget.sessionToUpdate!=null){
                          sessionToCreate.id = widget.sessionToUpdate.id;
                          _creationBloc.dispatch(UpdateCreation(sessionToCreate));
                        }else{
                          _creationBloc.dispatch(CreateCreation(sessionToCreate));
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date)
      setState(() {
        date = picked;
      });
  }

  Widget _buildQrCodeDropDown(){
    
    List<Map<String, Object>> getQrCode(List<User> qrCodes){
      var qrCodeMapped = List<Map<String, Object>>();

      qrCodes.forEach((qrCode) =>
          qrCodeMapped.add({"display": qrCode.label ,"value": qrCode.id})
      );

      return qrCodeMapped;
    }

   return BlocBuilder(
       bloc: _qrCodeBloc,
       builder: (BuildContext context, QrCodeState state) {
         if (state is QrCodeLoading) {
           return Center(
             child: CircularProgressIndicator(),
           );
         }

        /* if (state is QrCodeLoaded) {
           return DropDownFormField(
             titleText: 'qr code',
             hintText: 'Please choose one',
             value: qrCodeId,
             onSaved: (value) {
               setState(() {
                 qrCodeId = value;
               });
             },
             onChanged: (value) {
               setState(() {
                 qrCodeId = value;
               });
             },
           dataSource: getQrCode(state.qrCode),
             textField: 'display',
             valueField: 'value',
           );

         }*/

         return Center(
             child: Text(
               "can't load the q r codes in database ...",
               textAlign: TextAlign.center,
             ));
       }
   );
  }

}
