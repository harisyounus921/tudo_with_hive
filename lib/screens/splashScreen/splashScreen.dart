import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tudo_with_hive/screens/menuScreen/menuScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login();
  }
  void login(){
    Timer(const Duration(seconds: 2), (){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context)=>const menuScreen()),
         // (route)=>route.isFirst
              (route)=>false
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image(
            //height: double.infinity,fit: BoxFit.fitHeight,
            image: AssetImage("assets/splash.png"),
            //fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
/*
class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  startTime() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      return false;
    } else {
      prefs.setBool('seen', true);
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image(
            //height: double.infinity,fit: BoxFit.fitHeight,
            image: AssetImage("assets/splash.png"),
            //fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
  navigationPage() async {
    bool isFirstSeen = await checkFirstSeen();

    if (isFirstSeen) {
      return   Navigator.push(context, MaterialPageRoute(builder: (context)=>const menuScreen()));

    }
    return Navigator.pushNamed(context, '/onboardscreen');
  }
}

*/

