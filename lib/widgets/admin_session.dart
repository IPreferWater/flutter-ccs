

import 'package:ccs/creation_bloc/bloc.dart';
import 'package:ccs/models/session.dart';
import 'package:ccs/qrcode_bloc/bloc.dart';
import 'package:ccs/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'session_form_dialog.dart';

class AdminSession extends StatefulWidget {

  AdminSession();

  @override
  _AdminSessionState createState() => _AdminSessionState();
}

class _AdminSessionState extends State<AdminSession> {
  CreationBloc _creationBloc;

  @override
  void initState() {
    super.initState();
    _creationBloc = BlocProvider.of<CreationBloc>(context);
    _creationBloc.dispatch(LoadCreations());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _creationBloc,
      builder: (BuildContext context, CreationState state) {
        if (state is QrCodeLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is CreationsLoaded) {
          return Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.creations.length,
                itemBuilder: (context, index){
                  final displayedSession = state.creations[index];
                  return ListTile(
                    title: Text(displayedSession.id.toString()),
                    subtitle: Text('${displayedSession.label} ${displayedSession.date} (${displayedSession.usersID.length}))'),
                    trailing: _buildUpdateDeleteCreations(displayedSession),
                  );
                },
              ),
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => SessionFormDialog(),
                  );
                },
              )
            ],
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

  Row _buildUpdateDeleteCreations(Session displayedSession) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.face),
          onPressed: () {
            print("should navigate");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(session: displayedSession)),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => SessionFormDialog(
                sessionToUpdate: displayedSession,
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () {
            _creationBloc.dispatch(DeleteCreation(displayedSession));
          },
        ),
      ],
    );
  }
}

