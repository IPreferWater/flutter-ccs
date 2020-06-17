
import 'package:ccs/assets/ccs_icon.dart';
import 'package:ccs/widgets/admin_session.dart';
import 'package:ccs/widgets/admin_user.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  int _selectedMenu = 0;

  void _selectAdminMenu(int choice) {
    setState(() {
      _selectedMenu = choice;
    });
  }

  @override
  void initState() {
    super.initState();
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
      return AdminSession();
    }

    if (_selectedMenu == 1){
      return AdminUser();
    }
    return Text("please select menu");
  }
}
