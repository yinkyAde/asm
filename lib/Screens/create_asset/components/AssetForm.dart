import 'dart:convert';
import 'package:asm/Components/custom_surfix_icon.dart';
import 'package:asm/Components/form_error.dart';
import 'package:asm/Screens/dashboard/dashboard.dart';
import 'package:asm/model/Authentication.dart';
import 'package:asm/model/assetModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import '../../../Constants.dart';
import '../../../size_config.dart';

class AssetForm extends StatefulWidget {
  @override
  _AssetFormState createState() => _AssetFormState();
}

class _AssetFormState extends State<AssetForm> {
  // TextEditingController emailController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String username;
  String type;
  String location;
  String vallue;
  String date_of_birth;
  String uniqueCode;
  final List<String> errors = [];
  bool isEnabled = false;

  UserData userData = new UserData();
  UserAuth userAuth = new UserAuth();

  //datePicker
  DateTime _selectedDate;
  DateTime _date = DateTime.now();
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingControllerAssetName =
      TextEditingController();
  TextEditingController _textEditingControllerAssetUniqueCode =
      TextEditingController();
  TextEditingController _textEditingControllerType = TextEditingController();
  TextEditingController _textEditingControllerLocation =
      TextEditingController();
  TextEditingController _textEditingControllerAssetValue =
      TextEditingController();

  final DatabaseReference reference =
      FirebaseDatabase.instance.reference().child("Assets");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildAssetNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAssetTypeFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAssetUniqueCodeFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildDateFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAssetLocationFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAssetValueFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(10)),
          ProgressButton(
              borderRadius: 8,
              color: PrimaryColor,
              defaultWidget: const Text(
                'Add Asset',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              progressWidget: const CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.white),
              width: getProportionateScreenWidth(400),
              height: getProportionateScreenHeight(56),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  addAsset(
                      _textEditingControllerAssetName.text,
                      _textEditingControllerAssetUniqueCode.text,
                      _textEditingController.text,
                      _textEditingControllerType.text,
                      _textEditingControllerLocation.text,
                      _textEditingControllerAssetValue.text
                  );
                  Toast.show("Asset added successfully", context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.BOTTOM,
                      backgroundColor: successcolor);
                  _textEditingControllerAssetName.clear();
                  _textEditingControllerAssetUniqueCode.clear();
                  _textEditingController.clear();
                  _textEditingControllerType.clear();
                _textEditingControllerLocation.clear();
                _textEditingControllerAssetValue.clear();

                  int score = await Future.delayed(
                      const Duration(milliseconds: 1000), () => 42);

                  // After [onPressed], it will trigger animation running backwards, from end to beginning
                  // return () {
                  //   Login();
                  //   // Optional returns is returning a VoidCallback that will be called
                  //   // after the animation is stopped at the beginning.
                  //   // A best practice would be to do time-consuming task in [onPressed],
                  //   // and do page navigation in the returned VoidCallback.
                  //   // So that user won't missed out the reverse animation.
                  // };
                }
              }),
        ],
      ),
    );
  }

  TextFormField buildAssetNameFormField() {
    return TextFormField(
      controller: _textEditingControllerAssetName,
      obscureText: false,
      onSaved: (newValue) => username = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAssetNameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAssetNameNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Asset Name",
        hintText: "Enter asset name",
        labelStyle: TextStyle(
          color: PrimaryColor,
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/assets.svg"),
      ),
    );
  }

  TextFormField buildAssetTypeFormField() {
    return TextFormField(
      controller: _textEditingControllerType,
      obscureText: false,
      onSaved: (newValue) => type = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAssetTypeNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAssetTypeNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Asset type",
        hintText: "Enter asset type",
        labelStyle: TextStyle(
          color: PrimaryColor,
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/assets.svg"),
      ),
    );
  }

  TextFormField buildAssetUniqueCodeFormField() {
    return TextFormField(
      controller: _textEditingControllerAssetUniqueCode,
      obscureText: false,
      onSaved: (newValue) => uniqueCode = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAssetUniqueCodeNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAssetUniqueCodeNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Unique Code",
        hintText: "Enter unique code",
        labelStyle: TextStyle(
          color: PrimaryColor,
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/pincode.svg"),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1700),
        lastDate: DateTime(2040),
        initialDatePickerMode: DatePickerMode.year,
        // selectableDayPredicate: (DateTime val) =>
        // val.weekday == 6 || val.weekday == 7 ? false : true,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              colorScheme: ColorScheme.dark(
                  primary: PrimaryColor,
                  onPrimary: Colors.black,
                  onSecondary: Colors.black,
                  surface: Colors.white,
                  onSurface: Colors.black),
              dialogBackgroundColor: Colors.white,
              accentColor: PrimaryColor,
              cursorColor: Colors.black,
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Colors.black,
                    displayColor: Colors.black,
                  ),
            ),
            child: child,
          );
        });

    if (datePicker != null && datePicker != _date) {
      setState(() {
        _date = datePicker;
        _textEditingController
          ..text = DateFormat('yyyy-MM-dd').format(_date)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: _textEditingController.text.length,
              affinity: TextAffinity.upstream));
      });
    }
  }

  TextFormField buildDateFormField() {
    return TextFormField(
      controller: _textEditingController,
      // onSaved: (String val){
      //   strDate = val;
      // },
      onSaved: (newValue) => date_of_birth = newValue,
      onTap: () {
        _selectDate(context);
        FocusScope.of(context).requestFocus(new FocusNode());
      },

      validator: (value) {
        if (value.isEmpty) {
          addError(error: kDateNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Date Acquired",
        hintText: "Click to select Date",
        labelStyle: TextStyle(
          color: PrimaryColor,
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/calendar.svg"),
      ),
    );
  }

  TextFormField buildAssetLocationFormField() {
    return TextFormField(
      controller: _textEditingControllerLocation,
      obscureText: false,
      onSaved: (newValue) => location = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAssetLocationNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAssetLocationNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Asset Location",
        hintText: "Enter asset location",
        labelStyle: TextStyle(
          color: PrimaryColor,
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/location.svg"),
      ),
    );
  }

  TextFormField buildAssetValueFormField() {
    return TextFormField(
      controller: _textEditingControllerAssetValue,
      obscureText: false,
      onSaved: (newValue) => username = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAssetValueNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAssetValueNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Asset value",
        hintText: "Enter asset value",
        labelStyle: TextStyle(
          color: PrimaryColor,
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/list.svg"),
      ),
    );
  }
}
