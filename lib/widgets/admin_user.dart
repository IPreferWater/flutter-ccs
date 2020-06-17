

import 'package:ccs/models/user.dart';
import 'package:ccs/qrcode_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_form_dialog.dart';

class AdminUser extends StatefulWidget {
 // final VideoPlayerController videoController;

  AdminUser();

  @override
  _AdminUserState createState() => _AdminUserState();
}

class _AdminUserState extends State<AdminUser> {
  QrCodeBloc _qrCodeBloc;

  @override
  void initState() {
    super.initState();
    _qrCodeBloc = BlocProvider.of<QrCodeBloc>(context);
    _qrCodeBloc.dispatch(LoadQrCodes());
  }

  @override
  Widget build(BuildContext context) {
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
                    subtitle: Text('${displayedQrCode.label} (${displayedQrCode.code})'),
                    trailing: _buildUpdateDeleteQrCode(displayedQrCode),
                  );
                },
              ),
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => UserFormDialog(),
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
  Row _buildUpdateDeleteQrCode(User qrCodeDisplayed){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => UserFormDialog(
                userToUpdate: qrCodeDisplayed,
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
}

