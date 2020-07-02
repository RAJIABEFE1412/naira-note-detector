import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import "package:flutter_tts/flutter_tts.dart";

import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterTts flutterTts = FlutterTts();

  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  clickSpeak(text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
    await flutterTts.setSpeechRate(0.55);
  }

  // function for outputting the naira note recognized out as speech
  

  loadModel() async {
    String res;
//    res = await Tflite.loadModel(
//        model: "assets/detect.tflite", labels: "assets/labelmap.txt");

    switch (_model) {
//      case yolo:
//        res = await Tflite.loadModel(
//          model: "assets/yolov2_tiny.tflite",
//          labels: "assets/yolov2_tiny.txt",
//        );
//        break;
//
//      case mobilenet:
//        res = await Tflite.loadModel(
//            model: "assets/mobilenet_v1_1.0_224.tflite",
//            labels: "assets/mobilenet_v1_1.0_224.txt");
//        break;
//
//      case posenet:
//        res = await Tflite.loadModel(
//            model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
//        break;
//
      default:
        res = await Tflite.loadModel(
            model: "assets/detect.tflite",
            labels: "assets/labelmap.txt");
    }
   // print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;

    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: _model == ""
          ? InkWell(
              onTap: () {
                onSelect(ssd);
                clickSpeak("Detect Naira");
              },
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Container(
                        child: Text(
                          "Detect \n Naira",
                          style: TextStyle(
                            fontSize: 75,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),
    );
  }
}
