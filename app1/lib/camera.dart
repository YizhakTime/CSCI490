import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

enum Options { none, imagev5, imagev8, imagev8seg, frame, tesseract, vision }

late List<CameraDescription> cameras;

class Vision extends StatefulWidget {
  const Vision({super.key});

  @override
  State<Vision> createState() => _VisionState();
}

class _VisionState extends State<Vision> {
  late FlutterVision vision;
  Options option = Options.none;
  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
  }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeTesseractModel();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: task(option),
      floatingActionButton: SpeedDial(
        //margin bottom
        icon: Icons.menu, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: Colors.black12, //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor:
            Colors.deepPurpleAccent, //background color when menu is expanded
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        buttonSize: const Size(56.0, 56.0),
        children: [
          SpeedDialChild(
            //speed dial child
            child: const Icon(Icons.video_call),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Yolo on Frame',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.frame;
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.camera),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'YoloV8seg on Image',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.imagev8seg;
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.camera),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'YoloV8 on Image',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.imagev8;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget task(Options option) {
    // if (option == Options.imagev8) {
    //   return YoloV8Image(vision: vision);
    // }
    // if (option == Options.imagev8seg) {
    //   return YoloV8ImageDetect(vision: vision);
    // }
    if (option == Options.frame) {
      return YoloVideo(myvision: vision);
    }
    return const Center(child: Text("Choose option"));
  }
}

class YoloVideo extends StatefulWidget {
  final FlutterVision myvision;
  const YoloVideo({super.key, required this.myvision});

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  late CameraController mycontroller;
  late List<Map<String, dynamic>> results;
  CameraImage? myImage;
  bool loaded = false;
  bool detected = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cameras = await availableCameras();
    mycontroller = CameraController(cameras[0], ResolutionPreset.medium);
    mycontroller.initialize().then((value) {
      loadModel().then((value) {
        setState(() {
          loaded = true;
          detected = false;
          results = [];
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    mycontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!loaded) {
      return const Scaffold(
          body: Center(
        child: Text("Model is not loaded yet."),
      ));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: mycontroller.value.aspectRatio,
          child: CameraPreview(
            mycontroller,
          ),
        ),
        ...displayBoxesAroundRecognizedObjects(size),
        Positioned(
          bottom: 75,
          width: MediaQuery.of(context).size.width,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 5, color: Colors.white, style: BorderStyle.solid),
            ),
            child: detected
                ? IconButton(
                    onPressed: () async {
                      endDetection();
                    },
                    icon: const Icon(
                      Icons.stop,
                      color: Colors.red,
                    ),
                    iconSize: 50,
                  )
                : IconButton(
                    onPressed: () async {
                      await beginDetection();
                    },
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    iconSize: 50,
                  ),
          ),
        ),
      ],
    );
  } //build

  Future<void> loadModel() async {
    await widget.myvision.loadYoloModel(
        modelPath: 'assets/yolov8n.tflite',
        labels: 'assets/labels.txt',
        modelVersion: "yolov8",
        numThreads: 2,
        useGpu: true);
    setState(() {
      loaded = true;
    });
  } //loadModel

  Future<void> getFrame(CameraImage image) async {
    final res = await widget.myvision.yoloOnFrame(
        bytesList: image.planes.map((plane) => plane.bytes).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5);

    if (res.isNotEmpty) {
      setState(() {
        results = res;
        print("This is my ${results}");
      });
    }
  } //getFrame

  Future<void> beginDetection() async {
    setState(() {
      detected = true;
    });
    if (mycontroller.value.isStreamingImages) {
      return;
    }
    await mycontroller.startImageStream((image) async {
      if (detected) {
        myImage = image;
        getFrame(image);
      }
    });
  } //startDetection

  Future<void> endDetection() async {
    setState(() {
      detected = false;
      results.clear();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size video) {
    if (results.isEmpty) {
      return [];
    }

    double xDirection = video.width / (myImage?.height ?? 1);
    double yDirection = video.height / (myImage?.width ?? 1);
    Color getColor = const Color.fromARGB(255, 50, 233, 30);
    return results.map((res) {
      return Positioned(
        left: res["box"][0] * xDirection,
        top: res["box"][1] * yDirection,
        width: (res["box"][2] - res["box"][0]) * xDirection,
        height: (res["box"][3] - res["box"][1]) * yDirection,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: Colors.pink, width: 2.0)),
          child: Text(
            "${res['tag']} ${(res['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = getColor,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  } //display
}//YoloCamera Widget end
