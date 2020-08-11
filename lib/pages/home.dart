import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_app/pages/afternoon_shift.dart';
import 'package:new_app/pages/dashboard.dart';
import 'package:new_app/pages/day_shift.dart';
import 'package:new_app/pages/night_shift.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:weather_icons/weather_icons.dart';

class Home extends StatefulWidget {
  final BuildContext menuScreenContext;
  Home({Key key, this.menuScreenContext}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PersistentTabController _controller;
  bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      Dashboard(),
      DayShift(),
      AfternoonShift(),
      NightShift(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.dashboard,
          size: 20.0,
        ),
        title: "Dashboard",
        activeColor: Colors.purpleAccent,
        inactiveColor: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          WeatherIcons.day_cloudy,
          size: 20.0,
        ),
        title: ("Day"),
        activeColor: Colors.purpleAccent,
        inactiveColor: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          WeatherIcons.day_sunny,
          size: 20.0,
        ),
        title: ("Noon"),
        activeColor: Colors.purpleAccent,
        inactiveColor: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          WeatherIcons.night_clear,
          size: 20.0,
        ),
        title: ("Night"),
        activeColor: Colors.purpleAccent,
        inactiveColor: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: PersistentTabView(
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: false,
        backgroundColor: Color(0xFF3EB0F7),
        handleAndroidBackButtonPress: true,
        stateManagement: true,
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
          colorBehindNavBar: Colors.indigo,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.bounceIn,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style6, // Choose the nav bar style with this property
      ),
    );
  }
}
