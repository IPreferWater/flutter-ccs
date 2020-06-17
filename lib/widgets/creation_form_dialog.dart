import 'package:ccs/creation_bloc/bloc.dart';
import 'package:ccs/creation_bloc/creation_bloc.dart';
import 'package:ccs/models/qrcode.dart';
import 'package:ccs/qrcode_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../models/Creation.dart';
import '../models/Item.dart';
import 'dropdown_formfield.dart';

class CreationFormDialog extends StatefulWidget{

  final Creation creationToUpdate;

  CreationFormDialog({
    this.creationToUpdate
  });

  _CreationFormDialogState createState() => _CreationFormDialogState();

}
class _CreationFormDialogState extends State<CreationFormDialog> {

  CreationBloc _creationBloc;
  QrCodeBloc _qrCodeBloc;

  final String BEFORE = "before";
  final String AFTER = "after";
  final _formKey = GlobalKey<FormState>();
  final beforeTitle = TextEditingController();
  final beforeDescription = TextEditingController();
  final beforeImageUrl = TextEditingController();

  final afterTitle = TextEditingController();
  final afterDescription = TextEditingController();
  final afterImageUrl = TextEditingController();

  int qrCodeId;

  @override
  void initState(){
    super.initState();

    _creationBloc = BlocProvider.of<CreationBloc>(context);
    _creationBloc.dispatch(LoadCreations());


    _qrCodeBloc = BlocProvider.of<QrCodeBloc>(context);
    //we load only the free qrCode
    _qrCodeBloc.dispatch(LoadFreeQrCodes());

    if(this.widget.creationToUpdate!=null){
      final Creation creationToUpdate = widget.creationToUpdate;
      qrCodeId = creationToUpdate.qrCodeId;

      beforeTitle.text = creationToUpdate.before.title;
      beforeDescription.text = creationToUpdate.before.description;
      beforeImageUrl.text = creationToUpdate.before.imgPath;

      afterTitle.text = creationToUpdate.after.title;
      afterDescription.text = creationToUpdate.after.description;
      afterImageUrl.text = creationToUpdate.after.imgPath;
    }
  }


  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    print("image selected $image");
  }

  @override
  Widget build(BuildContext context) {
    return
      Dialog(
      elevation: 0.0,
      child: dialogContent(context),
    );
  }

  Future getImageFromGallery(String creation) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(creation==BEFORE){
      beforeImageUrl.text = image.absolute.path;
      return;
    }

    if(creation==AFTER){
      afterImageUrl.text = image.absolute.path;
    }

  }

  dialogContent(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              _buildQrCodeDropDown(),
              //before item
              TextFormField(
                controller: beforeTitle,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Title of the before item',
                  labelText: 'Title',
                ),
                validator: (String value) {
                  return value.isEmpty ? 'must not be empty' : null;
                },
              ),
              TextFormField(
                controller: beforeDescription,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Description of the before item',
                  labelText: 'Description',
                ),
                validator: (String value) {
                  return value.isEmpty ? 'must not be empty' : null;
                },
              ),
              Column(
                children: <Widget>[
                  RaisedButton(
                    onPressed: (){
                      getImageFromCamera();
                    },
                    child: Text('camera'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      getImageFromGallery(BEFORE);
                    },
                    child: Text('gallery'),
                  ),
                  TextField(
                    controller: beforeImageUrl,
                  )
                ],
              ),

              //after item
              TextFormField(
                controller: afterTitle,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Title of the after item',
                  labelText: 'Title',
                ),
                validator: (String value) {
                  return value.isEmpty ? 'must not be empty' : null;
                },
              ),
              TextFormField(
                controller: afterDescription,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Description of the after item',
                  labelText: 'Description',
                ),
                validator: (String value) {
                  return value.isEmpty ? 'must not be empty' : null;
                },
              ),
              Column(
                children: <Widget>[
                  RaisedButton(
                    onPressed: getImageFromCamera,
                    child: Text('camera'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      getImageFromGallery(AFTER);
                    },
                    child: Text('gallery'),
                  ),
                  TextField(
                    controller: afterImageUrl,
                  )
                ],
              ),


              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        final before = Item(
                            title: beforeTitle.text,
                            description: beforeDescription.text,
                            imgPath: beforeImageUrl.text
                        );

                        final after = Item(
                            title: afterTitle.text,
                            description: afterDescription.text,
                            imgPath: afterImageUrl.text
                        );
                        final creationToCreate = Creation(
                          qrCodeId: qrCodeId,
                            before: before,
                            after: after,
                            ingredients: <Item>[]
                        );

                        //TODO: make this code correct
                        if(widget.creationToUpdate!=null){
                          creationToCreate.id = widget.creationToUpdate.id;
                          _creationBloc.dispatch(UpdateCreation(creationToCreate));
                        }else{
                          _creationBloc.dispatch(CreateCreation(creationToCreate));
                        }

                        //in this form we put the state to load only free qrCode, we want to retrieve the other
                        _qrCodeBloc.dispatch(LoadQrCodes());
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Submit'),
                  )),
            ]
        )
    );
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

         if (state is QrCodeLoaded) {
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

         }

         return Center(
             child: Text(
               "can't load the q r codes in database ...",
               textAlign: TextAlign.center,
             ));
       }
   );
  }

}
