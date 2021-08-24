import 'dart:async';
import 'package:asm/Screens/sign_in/sign_in_screen.dart';
import 'package:asm/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Constants.dart';
import 'size_config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BU Asset Manager',
      theme: theme(),
      home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      //initialRoute: SplashScreen.routeName,
      //routes: routes,
    );
  }
}

// void main() =>
//     runApp(MaterialApp(
//       theme:
//       ThemeData(primaryColor: Colors.white, accentColor: Colors.yellowAccent),
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//     ));

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => new SignInScreen())));
    // Navigator.push(context, new MaterialPageRoute(builder:
    // (context) => new SplashScreens())));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var assetImage =
        new AssetImage('assets/images/logo.png'); // get image location
    var image = new Image(image: assetImage, width: 200.0, height: 200.0);
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FittedBox(
            child: Image.asset('assets/images/background.jpg'),
            fit: BoxFit.fill,
            // decoration: BoxDecoration(
            //     color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset("assets/images/logo.png",
                            height: 120, width: 120),
                      ),
                      Padding(padding: EdgeInsets.only(top: 0)),
                      Text("Bowen Asset Manager",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(25),
                            fontWeight: FontWeight.w300,
                            color: PrimaryColor
                          )),
                    ],
                  ),
                ),
              ),
              // Expanded(
              //   flex: 0,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       CircularProgressIndicator(
              //         valueColor:
              //             new AlwaysStoppedAnimation<Color>(PrimaryColor),
              //       ),
              //       Padding(padding: EdgeInsets.only(top: 55.0)),
              //     ],
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }
}
