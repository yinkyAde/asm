import 'package:asm/Components/no_account_text.dart';
import 'package:asm/Screens/create_asset/create_asset.dart';
import 'package:asm/Screens/list_asset/list_screen.dart';
import 'package:asm/Screens/scan_barcode/scan_barcode.dart';
import 'package:asm/Screens/sign_in/components/sign_form.dart';
import 'package:asm/Screens/sign_in/sign_in_screen.dart';
import 'package:asm/model/Authentication.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../../../Constants.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  UserData userData = new UserData();
  UserAuth userAuth = new UserAuth();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(40),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.001),
                SizedBox(height: getProportionateScreenWidth(5)),
                Text(
                  "Select an Option",
                  style: TextStyle(
                    color: Text_Small,
                    fontSize: getProportionateScreenWidth(20),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Container(
                  height: 320,
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: (230.0 / 220.0),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      DashboardCard(
                        imgSrc: FluentIcons.add_circle_24_regular,
                        title: "Add Asset",
                        press: () => Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new CreateAsset())),
                      ),
                      DashboardCard(
                        imgSrc: FluentIcons.list_24_regular,
                        title: "Assets List",
                        press: () => Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new AssetsList())),
                      ),
                      DashboardCard(
                        imgSrc: FluentIcons.qr_code_24_regular,
                        title: "Quick Scan",
                        press: () => Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new ScanScreen())),
                      ),
                      DashboardCard(
                        imgSrc: FluentIcons.pane_close_24_regular,
                        title: "Logout",
                        press: () {
                          userAuth.logOut();
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new SignInScreen()));
                          Toast.show("User logged out", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM,
                              backgroundColor: successcolor);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData imgSrc;
  final String title;
  final Function press;

  const DashboardCard({Key key, this.imgSrc, this.title, this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              offset: Offset(10, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: Shadowcolor,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Icon(
                    imgSrc,
                    size: 50,
                    color: PrimaryColor,
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    "$title",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Text_Small,
                        fontSize: getProportionateScreenWidth(15)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
