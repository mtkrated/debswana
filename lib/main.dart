import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:new_app/pages/login_register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_core/core.dart';

import 'pages/home.dart';
import 'services/auth.dart';
import 'services/production_update_api.dart';
import 'services/equipment_update_api.dart';
import 'utils/database_helper.dart';

void main() {
  SyncfusionLicense.registerLicense(
      'NT8mJyc2IWhia31hfWN9Z2doa3xiZnxhY2Fjc2FpYWNpY2JzAx5oPjwnOzY8ODY9Njo/JDYTOzwnPjI6P30wPD4=');
  runApp(new MyApp());
}

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with AfterLayoutMixin<IntroScreen> {
  @override
  void afterFirstLayout(BuildContext context) => _loadFromApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Preparing Data...",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future _loadFromApi() async {
    var apiProvider1 = ProductionUpdateApi();
    var apiProvider2 = EquipmentUpdateApi();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await apiProvider1.getAllProductionUpdates();
    await apiProvider2.getAllEquipmentUpdates().then((value) async {
      await prefs.setBool('seen', true).then((value) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new LoginRegister()));
      });
    });
    // await apiProvider2.getAllEquipmentUpdates().then((value) async {
    //   await prefs.setBool('seen', true).then((value) {
    //     Navigator.of(context).pushReplacement(
    //         new MaterialPageRoute(builder: (context) => new LoginRegister()));
    //   });
    // });
  }
}

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with AfterLayoutMixin<Welcome> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BaseAuth auth = new Auth();

    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      await auth.getCurrentUser().then((value) {
        if (value != null && value.email != null) {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => new Home()));
        } else
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => new LoginRegister()));
      }).catchError((onError) => print(onError));
    } else {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Welcome",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26.0),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "App",
      theme: ThemeData(
        primaryColor: Color(0xFF3EB0F7),
        accentColor: Color(0xFFD8ECF1),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: new Welcome(),
    );
  }
}
