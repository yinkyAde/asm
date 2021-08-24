import 'package:flutter/material.dart';
import '../../Constants.dart';
import '../../size_config.dart';
import 'components/body.dart';

class ScanScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Scan Barcode"),
      ),
      body: Body(),
    );
  }
}
