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
      body: Container(child: _buildHomePage()),
    );
  }

  Widget _buildHomePage() {
    if (widget.session == null) {
      return Text("select a session");
    }
    return _sSessionStartedWidget();
  }

  Widget _sSessionStartedWidget() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints)
    {
      return Container(
        child: Column(
          children: [
            BlocBuilder(
              bloc: _scanBloc,
              builder: (BuildContext context, ScanState state) {
                return Container(
                  height: constraints.maxHeight / 2,
                  width: constraints.maxWidth,
                  child: Column(
                    children: [
                      _buildTitle(),
                      Container(height : MediaQuery.of(context).size.width * 0.65,
                          width : MediaQuery.of(context).size.width * 0.65,
                          child: Center(child: _stateScanWidget(state))),
                      Container(
                          height : MediaQuery.of(context).size.width * 0.10,
                          width : constraints.maxWidth,
                           child: Center(
                            child: Text("${widget
                            .session.usersID.length} for this session"),
                          ))
                    ],
                  ),
                );
              },
            ),



            Container(
              height: constraints.maxHeight / 2,
              width: constraints.maxWidth,
              child: ScanWidget(
                context: context,
                scanBloc: _scanBloc,
                session: widget.session,
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _buildTitle() {
    return Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.session.label,
                style: new TextStyle(
                  fontSize: 40.0,
                  color: Colors.blue,
                )),
            //TODO degeulasse
            Text("       ${widget.session.date.day}/${widget.session.date.month}/${widget.session.date.year}-${widget.session.date.hour}:${widget.session.date.minute}",
                style: new TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueGrey,
                )),
          ],
        ));
  }



  Widget _stateScanWidget(ScanState state) {
    if (state is StateScanLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    String txt = "";
    Color color = Colors.blue;
    if (state is StateScanFinishSuccess) {
      txt = "Hello ${state.user.surname} ${state.user.name} have a good train";
    }

    else if (state is StateScanFinishNotFound) {
      txt = "user not found";
      color = Colors.redAccent;
    }

    else if (state is StateScanFinishUserAlreadyAdded) {
      txt = "${state.user.surname} ${state.user.name} already added";
      color = Colors.orange;
    }

    else if (state is StateScanFinishErrorDatabase) {
     txt = "error database";
     color = Colors.redAccent;
    }

    else if (state is StateScanFinishNotFound) {
     txt = "can't find a user with this code";
     color = Colors.orange;
    }

    else {
      txt = "error";
      color = Colors.redAccent;
    }
    return Text(txt, style: new TextStyle(
      fontSize: 40.0,
      color: color,
    ));
  }
}
