import 'dart:convert';
import 'package:asm/Components/custom_surfix_icon.dart';
import 'package:asm/Components/form_error.dart';
import 'package:asm/Screens/sign_in/sign_in_screen.dart';
import 'package:asm/model/Authentication.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../../../Constants.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String username;
  String email;
  String phonenumber;
  String password;
  String confirm_password;
  String gettoken;
  bool remember = false;
  final List<String> errors = [];

  UserData userData = new UserData();
  UserAuth userAuth = new UserAuth();

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

  showSuccessfulToast(String value) {
    Toast.show(value, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundColor: successcolor);
  }

  showUnSuccessfulToast(String value) {
    Toast.show(value, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundColor: unsuccessfulcolor);
  }

  _createUser() {
    userAuth.createUser(userData).then((onValue) {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => new SignInScreen()));
      showSuccessfulToast(onValue);
    }).onError((error, stackTrace) => showUnSuccessfulToast(error.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFullnameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          // buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          ProgressButton(
              borderRadius: 8,
              color: PrimaryColor,
              defaultWidget: const Text(
                'Sign Up',
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
                  _createUser();
                  int score = await Future.delayed(
                      const Duration(milliseconds: 1000), () => 42);
                  // After [onPressed], it will trigger animation running backwards, from end to beginning
                  // return () {
                  //   CreateAccount();
                  //
                  //   // Optional returns is returning a VoidCallback that will be called
                  //   // after the animation is stopped at the beginning.
                  //   // A best practice would be to do time-consuming task in [onPressed],
                  //   // and do page navigation in the returned VoidCallback.
                  //   // So that user won't missed out the reverse animation.
                  // };

                }
              }),
          // DefaultButton(
          //   text: "Continue",
          //   press: () {
          //     if (_formKey.currentState.validate()) {
          //       _formKey.currentState.save();
          //       CreateAccount();
          //       // if all are valid then go to success screen
          //       // Navigator.push(context, new MaterialPageRoute(builder:
          //       //     (context) => new AlmostDoneScreen()));
          //     }
          //   },
          // ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirm_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == confirm_password) {
          removeError(error: kMatchPassError);
        }
        confirm_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        labelStyle: TextStyle(
          color: PrimaryColor,
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => userData.password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 6) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 6) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        labelStyle: TextStyle(
          color: PrimaryColor,
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildFullnameFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => userData.fullname = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kFullnameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kFullnameNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Fullname",
        hintText: "Enter your fullname",
        labelStyle: TextStyle(
          color: PrimaryColor,
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => userData.email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kEmailNullError)) {
          removeError(error: kEmailNullError);
          //errors.remove(kEmailNullError);

        } else if (emailValidatorRegExp.hasMatch(value) &&
            errors.contains(kInvalidEmailError)) {
          addError(error: kInvalidEmailError);
          //errors.add(kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty && !errors.contains(kEmailNullError)) {
          setState(() {
            errors.add(kEmailNullError);
          });
        } else if (!emailValidatorRegExp.hasMatch(value) &&
            !errors.contains(kInvalidEmailError)) {
          setState(() {
            errors.add(kInvalidEmailError);
          });
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        labelStyle: TextStyle(
          color: PrimaryColor,
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
