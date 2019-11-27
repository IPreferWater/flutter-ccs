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
  final _formKey = GlobalKey<FormState>();
  final beforeTitle = TextEditingController();
  final beforeDescription = TextEditingController();

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
      print("image selected $image");
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print("image selected $image");
  }

  return showDialog(

      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
              key: _formKey,
              child: Column(children: <Widget>[
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
                RaisedButton(
                 onPressed: getImageFromCamera,
                  child: Text('camera'),
                ),
                RaisedButton(
                  onPressed: getImageFromGallery,
                  child: Text('gallery'),
                ),

                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                         print('seems to be ok ${beforeTitle.text}');

                         final before = Item(
                             title: beforeTitle.text,
                             description: "before long desc",
                             imgPath: "path/to/beforeImg.jpg"
                         );

                         final after = Item(
                             title: "afterTitle",
                             description: "after long desc",
                             imgPath: "path/to/beforeImg.jpg"
                         );
                         final creationToCreate = Creation(
                             before: before,
                             after: after,
                             ingredients: <Item>[]
                         );

                         _creationBloc.dispatch(CreateCreation(creationToCreate));
                        }
                      },
                      child: Text('Submit'),
                    )),
              ])),
        );
      });
}
