import 'dart:convert';
import 'package:asm/Components/custom_surfix_icon.dart';
import 'package:asm/Components/form_error.dart';
import 'package:asm/Screens/dashboard/dashboard.dart';
import 'package:asm/model/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../../../Constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  // TextEditingController emailController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  final List<String> errors = [];
  bool isEnabled = false;

  UserData userData = new UserData();
  UserAuth userAuth = new UserAuth();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  _login() {
    userAuth.verifyUser(userData).then((onValue) {
      if (onValue == "User Successfully Logged in") {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => new Dashboard()));
        showSuccessfulToast(onValue);
      } else {
        showUnSuccessfulToast(onValue);
      }
    }).onError((error, stackTrace) =>
        showUnSuccessfulToast(error.toString()));


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
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(50)),
          ProgressButton(
              borderRadius: 8,
              color: PrimaryColor,
              defaultWidget: const Text(
                'Sign In',
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
                  _login();
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

  TextFormField buildPasswordFormField() {
    return TextFormField(
      //controller: passwordController,
      obscureText: true,
      onSaved: (newValue) => userData.password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 6) {
          removeError(error: kShortPassError);
        }
        return null;
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

  TextFormField buildEmailFormField() {
    return TextFormField(
      //controller: emailController,
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
