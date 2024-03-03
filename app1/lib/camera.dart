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
            label: 'YoloV8 on Image',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.imagev8;
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.exit_to_app),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Exit',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget task(Options option) {
    if (option == Options.imagev8) {
      return YoloV8(vision: vision);
    }
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

  String getDetected(List<Map<String, dynamic>> results) {
    String detectedImageText = '';
    // results.forEach((element) => print(element['tag']));
    for (var res in results) {
      detectedImageText = res['tag'].toString();
    }
    return detectedImageText;
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
        String output = getDetected(results);
        print(output);
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
} //YoloCamera Widget end

class YoloV8 extends StatefulWidget {
  final FlutterVision vision;
  const YoloV8({super.key, required this.vision});

  @override
  State<YoloV8> createState() => _YoloV8State();
}

class _YoloV8State extends State<YoloV8> {
  late List<Map<String, dynamic>> picresults;
  File? image;
  int imgHeight = 1;
  int imgWidth = 1;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    loadYoloModel().then((value) {
      setState(() {
        picresults = [];
        loaded = true;
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size mysize = MediaQuery.of(context).size;
    if (!loaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model is not loaded, waiting for it."),
        ),
      );
    } //loaded

    return Stack(
      fit: StackFit.expand,
      children: [
        image != null ? Image.file(image!) : const SizedBox(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: chooseImage,
                  child: const Text("Select an image.")),
              ElevatedButton(
                  onPressed: yoloOnImage, child: const Text("Detect."))
            ],
          ),
        ),
        ...displayBoxesatObjects(mysize),
      ],
    );
  } //build

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        modelPath: 'assets/yolov8n.tflite',
        labels: 'assets/labels.txt',
        modelVersion: "yolov8",
        useGpu: true,
        numThreads: 2,
        quantization: false);
    setState(() {
      loaded = true;
    });
  } //loadModel

  Future<void> chooseImage() async {
    final ImagePicker pick = ImagePicker();
    final XFile? photo = await pick.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        image = File(photo.path);
      });
    } //photo
  } //chooseImage

  yoloOnImage() async {
    picresults.clear();
    Uint8List byte = await image!.readAsBytes();
    final testImg = await decodeImageFromList(byte);
    imgHeight = testImg.height;
    imgWidth = testImg.width;
    final res = await widget.vision.yoloOnImage(
        bytesList: byte,
        imageHeight: testImg.height,
        imageWidth: testImg.width,
        iouThreshold: 0.8,
        confThreshold: 0.4,
        classThreshold: 0.5);

    if (res.isNotEmpty) {
      setState(() {
        picresults = res;
      });
    } //not empty
  } //yoloonImage

  List<Widget> displayBoxesatObjects(Size screen) {
    if (picresults.isEmpty) {
      return [];
    }

    double factorX = screen.width / (imgWidth);
    double imgRatio = imgWidth / imgHeight;
    double newWidth = imgWidth * factorX;
    double newHeight = newWidth / imgRatio;
    double factorY = newHeight / (imgHeight);
    double pady = (screen.height - newHeight) / 2;
    Color pickcolor = const Color.fromARGB(255, 50, 233, 30);
    return picresults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY + pady,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
              "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                background: Paint()..color = pickcolor,
                color: Colors.white,
                fontSize: 18.0,
              )),
        ),
      );
    }).toList();
  }
} //Yolov8class