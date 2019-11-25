import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccs/models/Creation.dart';
import 'package:ccs/creation_bloc/bloc.dart';

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
          _displayDialog(context);
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

_displayDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Title of the before item',
                    labelText: 'Title',
                  ),
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return value.isEmpty ? 'must not be empty' : null;
                  },
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Data')));
                        }
                      },
                      child: Text('Submit'),
                    )),
              ])),
        );
      });
}
