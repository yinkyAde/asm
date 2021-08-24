import 'dart:typed_data';

import 'package:asm/Screens/scan_barcode/components/body.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:toast/toast.dart';
import '../../../Constants.dart';
import '../../../size_config.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class Body extends StatefulWidget {
  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  Uint8List bytes = Uint8List(0);
  final DatabaseReference reference =
      FirebaseDatabase.instance.reference().child("Assets");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FirebaseAnimatedList(
                    shrinkWrap: true,
                    query: reference,
                    itemBuilder: (
                      BuildContext context,
                      DataSnapshot snapshot,
                      Animation<double> animation,
                      int index,
                    ) {
                      return new Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Dismissible(
                          key: Key(reference.child(snapshot.key).toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() {
                              reference.child(snapshot.key).remove();
                            });
                          },
                          background: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFE6E6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Spacer(),
                                SvgPicture.asset("assets/icons/Trash.svg"),
                              ],
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _onButtonPressed(index, snapshot);
                                },
                                child: Container(
                                  height: 70.0,
                                  width: getProportionateScreenWidth(320),
                                  padding: EdgeInsets.all(
                                      getProportionateScreenWidth(10)),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "${snapshot.value['assetName']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(int index, DataSnapshot snapshot) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: getProportionateScreenHeight(200),
            //color: Color(0xFFf8f8f8),
            child: _buildBottomNavigationSheet(index, snapshot),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
              ),
            ),
          );
        });
  }

  Padding _buildBottomNavigationSheet(int index, DataSnapshot snapshot) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: getProportionateScreenHeight(40)),
              GestureDetector(
                onTap: () {
                  _showQrDialog(index,snapshot);
                },
                child: Text("Generate Qr Code",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Text_Small,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              GestureDetector(
                onTap: () {
                  _showDialog(index, snapshot);
                },
                child: Text("View Asset",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Text_Small,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              GestureDetector(
                onTap: () {
                  Toast.show("Under Development", context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.BOTTOM,
                      backgroundColor: Colors.black);
                },
                child: Text("Update Asset",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Text_Small,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
            ]),
      ),
    );
  }

  void _showDialog(int index, DataSnapshot snapshot) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return assetDialog(context, index, snapshot);
      },
    );
  }

  Dialog assetDialog(context, int index, DataSnapshot snapshot) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 250.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'AssetName: ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: getProportionateScreenWidth(5)),
                  Text(
                    '${snapshot.value['assetName']}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'AssetType:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: getProportionateScreenWidth(5)),
                  Text(
                    '${snapshot.value['assetType']}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'UniqueCode: ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: getProportionateScreenWidth(5)),
                  Text(
                    '${snapshot.value['uniqueAssetName']}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'DateAcquired: ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: getProportionateScreenWidth(5)),
                  Text(
                    '${snapshot.value['assetDate']}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'AssetLocation: ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: getProportionateScreenWidth(5)),
                  Text(
                    '${snapshot.value['assetLocation']}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'assetValue',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: getProportionateScreenWidth(5)),
                  Text(
                    '${snapshot.value['assetValue']}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQrDialog(int index, DataSnapshot snapshot) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return assetQrDialog(context, index, snapshot);
      },
    );
  }

  Dialog assetQrDialog(context, int index, DataSnapshot snapshot) {
    String value = "AssetName: ${snapshot.value['assetName']}\n"
        "AssetType: ${snapshot.value['assetType']}\n"
        "AssetType: ${snapshot.value['assetType']}\n"
        "UniqueCode: ${snapshot.value['uniqueAssetName']}\n"
        "DateAcquired: ${snapshot.value['assetDate']}\n"
        "AssetLocation: ${snapshot.value['assetLocation']}\n"
        "AssetValue: ${snapshot.value['assetValue']}\n";
    _generateBarCode(value);

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[_qrCodeWidget(bytes, context)],
          ),
        ),
      ),
    );
  }

  Widget _qrCodeWidget(Uint8List bytes, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          // boxShadow: [
          //   BoxShadow(
          //     offset: Offset(10, 17),
          //     blurRadius: 17,
          //     spreadRadius: -23,
          //     color: Shadowcolor,
          //=   ),
          //],
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.verified_user, size: 18, color: Colors.green),
                  Text('  Generated Qrcode', style: TextStyle(fontSize: 15)),
                  Spacer(),
                  Icon(Icons.more_vert, size: 18, color: Colors.black54),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 190,
                    child: bytes.isEmpty
                        ? Center(
                            child: Text('Empty code ... ',
                                style: TextStyle(color: Colors.black38)),
                          )
                        : Image.memory(bytes),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7, left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        // Expanded(
                        //   flex: 5,
                        //   child: GestureDetector(
                        //     child: Text(
                        //       'remove',
                        //       style:
                        //           TextStyle(fontSize: 14, color: Colors.blue),
                        //       textAlign: TextAlign.left,
                        //     ),
                        //     onTap: () => this.setState(() => this.bytes = Uint8List(0)),
                        //   ),
                        // ),
                        // Text('|',
                        //     style:
                        //         TextStyle(fontSize: 15, color: Colors.black26)),
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: () async {
                              final success =
                                  await ImageGallerySaver.saveImage(this.bytes);
                              print(success);
                              if (success) {
                                Toast.show("QRCode Successfully Saved", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM,
                                    backgroundColor: successcolor);
                              } else {
                                Toast.show("Unable to save", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM,
                                    backgroundColor: unsuccessfulcolor);
                              }
                            },
                            child: Text(
                              'save',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
          ],
        ),
      ),
    );
  }

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }
}
