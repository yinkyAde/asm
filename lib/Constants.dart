import 'package:asm/size_config.dart';
import 'package:flutter/material.dart';

const BackgroundColor =Color(0xFFf8f8f8);
const PrimaryColor =Color(0xFF2196f3);
const Text_Big = Color(0xff000000);
const Text_Small = Color(0xff737373);
const Shadowcolor = Color(0xffe6e6e6);

const successcolor = Color(0xFF619A46);
const unsuccessfulcolor = Color(0xFFFF0000);

const kAnimationDuration = Duration(milliseconds: 200);





final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kAddressNullError = "Please Enter your address";
const String kFullnameNullError = "Please Enter your Fullname";
const String kDateNullError = "Please Choose Date";
const String kAssetNameNullError = "Please Enter asset name";
const String kAssetUniqueCodeNullError = "Please Enter unique code";
const String kAssetTypeNullError = "Please Enter type";
const String kAssetLocationNullError = "Please Enter location";
const String kAssetValueNullError = "Please Enter value";



final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: Text_Big),
  );
}


//Sap Green = #438029
//Palm Leaf = #619A46
//Asparagus = #7DAA6A
//Sunray = #E1C158
//Gold (Metallic) = #D4AF37
//Light Gold = #B29700