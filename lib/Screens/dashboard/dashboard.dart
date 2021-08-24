import 'package:flutter/material.dart';
import '../../Constants.dart';
import '../../size_config.dart';
import 'package:asm/Screens/dashboard/components/body.dart';


class Dashboard extends StatefulWidget {
  DashboardState createState() => DashboardState();
}


class DashboardState extends State<Dashboard> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit BUI Asset Manager'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No', style: TextStyle(color: PrimaryColor)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes', style: TextStyle(color: PrimaryColor)),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
    child: new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dashboard"),
      ),
      body: Body(),
    ),
    );
  }
}