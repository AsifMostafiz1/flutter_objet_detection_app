import 'package:flutter/material.dart';
import 'package:opject_detect_appp/MyFlashScreen.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;
Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  cameras  = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:"Object Detection App",
      home: MyFlashScreen(),

    );
  }
}
