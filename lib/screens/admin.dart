import 'package:ccs/models/creation_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccs/models/Creation.dart';
import 'package:ccs/creation_bloc/bloc.dart';

class AdminScreen extends StatefulWidget {
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  CreationBloc _creationBloc;
  int _selectedMenu = 0;

  void _selectAdminMenu(int choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedMenu = choice;
    });
  }

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.directions_car),
            onPressed: () {
              _selectAdminMenu(0);
            },
          ),
          // action button
          IconButton(
            icon: Icon(Icons.directions_bike),
            onPressed: () {
              _selectAdminMenu(1);
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => CreationFormDialog(
                context: context, creationBloc: _creationBloc),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedMenu == 0){
      return _creationMenu();
    }

    if (_selectedMenu == 1){
      return _qrMenu();
    }
    return Text("please select menu");
  }

  Widget _qrMenu() {
    return Text("todo");
  }

  Widget _creationMenu() {
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
                subtitle: Text(
                    'qr code : ${displayedCreation.qrCode} before : ${displayedCreation.before.title} after : ${displayedCreation.after.title}'),
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
            showDialog(
              context: context,
              builder: (BuildContext context) => CreationFormDialog(
                // context: context,
                creationBloc: _creationBloc,
                creationToUpdate: displayedCreation,
              ),
            );
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
