import 'package:flutter/material.dart';
import 'package:opject_detect_appp/HomePage.dart';
import 'package:splashscreen/splashscreen.dart';

class MyFlashScreen extends StatefulWidget {
  @override
  _MyFlashScreenState createState() => _MyFlashScreenState();
}

class _MyFlashScreenState extends State<MyFlashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(

      seconds: 5,
      navigateAfterSeconds: HomePage(),
      imageBackground: Image.asset('assets/splash.jpg').image,
      useLoader: true,
      loaderColor: Colors.white,
      loadingText: Text('Loading...',style: new TextStyle(color: Colors.white,fontSize: 20),),
    );
  }
}

