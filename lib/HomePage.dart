import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:opject_detect_appp/main.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isWorking = false;
  String results = "";
  String finalResult ="";
  CameraImage imgCamera;
  CameraController cameraController;

  loadModel() async
  {
    await Tflite.loadModel(
      model: "assets/mobilenet_v1_1.0_224.tflite",
      labels: "assets/mobilenet_v1_1.0_224.txt",
    );
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  imgCamera = imageFromStream,
                  runModelOnStremFrames(),

                }
            });
      });
    });
  }


  runModelOnStremFrames() async
  {
      if(imgCamera!= null)
        {
          var recognitions = await Tflite.runModelOnFrame(
            bytesList: imgCamera.planes.map((plane){
              return plane.bytes;
            }).toList(),

            imageHeight: imgCamera.height,
            imageWidth: imgCamera.width,
            imageMean: 127.0,
            imageStd: 127.0,
            numResults: 2,
            threshold: 0.1,
            rotation: 90,
            asynch: true,
          );
          results = "";
          finalResult = "";
          recognitions.forEach((response) {
              results += response["label"]+ "  " + (response["confidence"] as double).toStringAsFixed(2) + "\n\n";

              if(response["confidence"]> 0.5)
                {
                  finalResult = response["label"];
                }
          });
          setState(() {
            results;
          });
          isWorking = false;
        }
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }
  @override
  void dispose() async
  {
    super.dispose();

    await Tflite.close();
    cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: new AppBar(
            title: Text("Detect Your Object"),
          ),
          body: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 360,
                        height: 270,
                        child: Image.asset('assets/camera.jpg'),
                      ),
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: ()
                        {
                          initCamera();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 270,
                          width: 360,
                          child: imgCamera == null
                              ? Container(
                            height: 270,
                            width: 360,
                            child: Icon(Icons.photo_camera_front,color: Colors.white,size: 100,),
                          )
                              : AspectRatio(
                            aspectRatio: cameraController.value.aspectRatio,
                            child: CameraPreview(cameraController),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          results,
                          style: new TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(finalResult),

                      ],
                    ),

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
