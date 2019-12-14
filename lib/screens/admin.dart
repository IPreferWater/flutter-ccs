
import 'package:ccs/assets/ccs_icon.dart';
import 'package:ccs/widgets/creation_form_dialog.dart';
import 'package:ccs/models/qrcode.dart';
import 'package:ccs/qrcode_bloc/bloc.dart';
import 'package:ccs/widgets/qrcode_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccs/models/Creation.dart';
import 'package:ccs/creation_bloc/bloc.dart';

class AdminScreen extends StatefulWidget {
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  CreationBloc _creationBloc;
  QrCodeBloc _qrCodeBloc;
  int _selectedMenu = 0;

  void _selectAdminMenu(int choice) {
    setState(() {
      _selectedMenu = choice;
    });
  }

  @override
  void initState() {
    super.initState();
    _creationBloc = BlocProvider.of<CreationBloc>(context);
    _creationBloc.dispatch(LoadCreations());

    _qrCodeBloc = BlocProvider.of<QrCodeBloc>(context);
    _qrCodeBloc.dispatch(LoadQrCodes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creation app'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.description),
            onPressed: () {
              _selectAdminMenu(0);
            },
          ),
          IconButton(
            icon: Icon(CcsIcon.barcode),
            onPressed: () {
              _selectAdminMenu(1);
            },
          ),
        ],
      ),
      body: _buildBody(),
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
    return BlocBuilder(
      bloc: _qrCodeBloc,
      builder: (BuildContext context, QrCodeState state) {
      if (state is QrCodeLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state is QrCodeLoaded) {
        return Column(
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: state.qrCode.length,
              itemBuilder: (context, index){
                final displayedQrCode = state.qrCode[index];
                return ListTile(
                  title: Text(displayedQrCode.id.toString()),
                  subtitle: Text('${displayedQrCode.label} (${displayedQrCode.qrCode})'),
                  trailing: _buildUpdateDeleteQrCode(displayedQrCode),
                );
              },
            ),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => QrCodeFormDialog(),
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
          return
            Column(
                children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
            itemCount: state.creations.length,
              itemBuilder: (context, index) {
                final displayedCreation = state.creations[index];
                return ListTile(
                  title: Text(displayedCreation.id.toString()),
                  subtitle: Text(
                      'qr code : ${displayedCreation.qrCode} before : ${displayedCreation.before.title} after : ${displayedCreation.after.title}'),
                  trailing: _buildUpdateDeleteCreations(displayedCreation),
                );
              },
            ),
                  FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => CreationFormDialog(),
                      );
                    },
                  )
                  ]
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

  Row _buildUpdateDeleteQrCode(QrCode qrCodeDisplayed){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => QrCodeFormDialog(
               qrCodeToUpdate: qrCodeDisplayed,
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () {
            _qrCodeBloc.dispatch(DeleteQrCode(qrCodeDisplayed));
          },
        ),
      ],
    );
  }

  Row _buildUpdateDeleteCreations(Creation displayedCreation) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => CreationFormDialog(
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
