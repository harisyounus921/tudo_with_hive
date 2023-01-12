import 'dart:async';
import 'package:flutter/material.dart';
import '../homeScreen/homeScreen.dart';

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
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen2()));
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
