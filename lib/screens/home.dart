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
    return _sSessionStartedWidget();
  }

  Widget _sSessionStartedWidget(){
    return BlocBuilder(
      bloc: _scanBloc,
      builder: (BuildContext context, ScanState state) {
        return ListView(padding: const EdgeInsets.all(8),
        children: [
          Text(widget.session.label),
          _stateScanWidget(state),
          Text("${widget.session.usersID.length} for this session"),
          ScanWidget(
            context: context,
            scanBloc: _scanBloc,
            session: widget.session,
          )
        ],);

      },
    );
  }

  Widget _stateScanWidget(ScanState state) {

        if (state is StateScanFinishSuccess) {
          return Column(
            children: [
              Text("Hello ${state.user.surname} ${state.user.name} have a good train")
            ],
          );
        }

        if (state is StateScanLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is StateScanFinishNotFound) {
          return Text("user not found");
        }

        if (state is StateScanFinishUserAlreadyAdded) {
          return Text("${state.user.surname} ${state.user.name} already added");
        }

        if (state is StateScanFinishErrorDatabase) {
          return Text("error database");
        }

        if (state is StateScanFinishNotFound) {
          return Text("can't find a user with this code");
        }
        return Text("error");

  }
}
