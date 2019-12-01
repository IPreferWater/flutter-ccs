import 'package:ccs/models/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccs/models/Creation.dart';
import 'package:ccs/models/Item.dart';
import 'package:ccs/creation_bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

class AdminScreen extends StatefulWidget {
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creation app'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _displayDialog(context, _creationBloc);
        },
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder(
      bloc: _creationBloc,
      // Whenever there is a new state emitted from the bloc, builder runs.
      builder: (BuildContext context, CreationState state) {
        if (state is CreationsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CreationsLoaded) {
          return ListView.builder(
            itemCount: state.creations.length,
            itemBuilder: (context, index) {
              final displayedCreation = state.creations[index];
              return ListTile(
                title: Text(displayedCreation.id.toString()),
                subtitle: Text('possible text'),
                trailing: _buildUpdateDeleteButtons(displayedCreation),
              );
            },
          );
        }
        return Center(
            child: Text(
          "error ?",
          textAlign: TextAlign.center,
        ));
      },
    );
  }

  Row _buildUpdateDeleteButtons(Creation displayedCreation) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            _creationBloc.dispatch(DeleteCreation(displayedCreation));
          },
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () {
            _creationBloc.dispatch(DeleteCreation(displayedCreation));
          },
        ),
      ],
    );
  }


}

_displayDialog(BuildContext context, CreationBloc _creationBloc) async {

  const String BEFORE = "before";
  const String AFTER = "after";
  final _formKey = GlobalKey<FormState>();
  final beforeTitle = TextEditingController();
  final beforeDescription = TextEditingController();
  final beforeImageUrl = TextEditingController();

  final afterTitle = TextEditingController();
  final afterDescription = TextEditingController();
  final afterImageUrl = TextEditingController();

  String _myActivity;


  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
      print("image selected $image");
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

  return showDialog(

      context: context,
      builder: (context) {
        return AlertDialog(
            content: Container(
              width: double.maxFinite,
          child: Form(
              key: _formKey,
              child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    DropDownFormField(
                      titleText: 'My workout',
                      hintText: 'Please choose one',
                    /*  onChanged: (value) {
                        setState(() {
                          _myActivity = value;
                        });
                      },*/
                        value: _myActivity,
                        dataSource: [{
                          "display": "qrcode 1",
                          "value": 1,
                        },
                          {
                            "display": "qrcode 2",
                            "value": 2,
                          }],
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
                             before: before,
                             after: after,
                             ingredients: <Item>[]
                         );
                         _creationBloc.dispatch(CreateCreation(creationToCreate));

                         Navigator.of(context).pop();
                        }
                      },
                      child: Text('Submit'),
                    )),
              ])),
            )
        );
      });
}
