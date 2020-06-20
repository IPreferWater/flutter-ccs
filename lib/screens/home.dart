import 'package:ccs/models/session.dart';
import 'package:ccs/scan_bloc/bloc.dart';
import 'package:ccs/screens/admin.dart';
import 'package:ccs/widgets/scan_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final Session session;

  HomePage({this.session});

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScanBloc _scanBloc;

  @override
  void initState() {
    super.initState();
    _scanBloc = BlocProvider.of<ScanBloc>(context);

    //_scanBloc.dispatch(ScanWaiting());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Before After'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.description),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminScreen()),
              );
            },
          )
        ],
      ),
      body: Center(child: _buildHomePage()),
    );
  }

  Widget _buildHomePage() {
    if (widget.session == null) {
      return Text("select a session");
    }
    return ListView(padding: const EdgeInsets.all(8), children: <Widget>[
      _beforeAfterWidget(),
      ScanWidget(
        context: context,
        scanBloc: _scanBloc,
      ),
      RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          splashColor: Colors.blueGrey,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminScreen()),
            );
          },
          child: const Text('admin')),
    ]);
  }

  Widget _beforeAfterWidget() {
    return BlocBuilder(
      bloc: _scanBloc,
      builder: (BuildContext context, ScanState state) {
        if (state is StateScanWaiting) {
          return Text(
            "let's scan !",
          );
        }

        if (state is StateScanLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is StateScanFinishSuccess) {
          //update database add user id in sessions.users

          // display some informations about the current user
        }

        if (state is StateScanFinishNotFound) {
          return Text("can't find this code");
        }
        return Text("error");
      },
    );
  }
}
