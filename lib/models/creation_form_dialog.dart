import 'package:ccs/creation_bloc/bloc.dart';
import 'package:ccs/creation_bloc/creation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'Creation.dart';
import 'Item.dart';
import 'dropdown_formfield.dart';

class CreationFormDialog extends StatefulWidget{

  final BuildContext context;
  final CreationBloc creationBloc;

  CreationFormDialog({
    @required this.context,
    @required this.creationBloc,
  });

  _CreationFormDialogState createState() => _CreationFormDialogState();


}
class _CreationFormDialogState extends State<CreationFormDialog> {

  final String BEFORE = "before";
  final String AFTER = "after";
  final _formKey = GlobalKey<FormState>();
  final beforeTitle = TextEditingController();
  final beforeDescription = TextEditingController();
  final beforeImageUrl = TextEditingController();

  final afterTitle = TextEditingController();
  final afterDescription = TextEditingController();
  final afterImageUrl = TextEditingController();

  int qrCode;

  CreationBloc _creationBloc;

  @override
  void initState() {
    super.initState();
    // Obtaining the CreationBloc instance through BlocProvider which is an InheritedWidget
    _creationBloc = BlocProvider.of<CreationBloc>(context);
    // Events can be passed into the bloc by calling dispatch.
    // We want to start loading creations right from the start.
    _creationBloc.dispatch(LoadCreations());
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
      beforeImageUrl.text = image.absolute.toString();
      return;
    }

    if(creation==AFTER){
      afterImageUrl.text = image.absolute.toString();
    }

    print("image selected $image");
    print("image absolute uri =  ${image.absolute}");
  }

  dialogContent(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              DropDownFormField(
                titleText: 'My workout',
                hintText: 'Please choose one',
                value: qrCode,
                onSaved: (value) {
                  setState(() {
                    qrCode = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    qrCode = value;
                  });
                },
                  dataSource: [
                    {
                      "display": "qr 1",
                      "value": 1,
                    },
                    {
                      "display": "qr 2",
                      "value": 2,
                    }
                  ],
                textField: 'display',
                valueField: 'value',
              ),
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
                          qrCode: qrCode,
                            before: before,
                            after: after,
                            ingredients: <Item>[]
                        );
                        widget.creationBloc.dispatch(CreateCreation(creationToCreate));

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
