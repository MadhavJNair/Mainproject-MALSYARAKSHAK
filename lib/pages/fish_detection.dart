import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img_lib;

class CaptureImg extends StatefulWidget {
  @override
  _CaptureImgState createState() => _CaptureImgState();
}

class _CaptureImgState extends State<CaptureImg> {
  late Interpreter _interpreter;
  final List<String> _classNames = [
    "Aeromoniasis",
    "Argulus",
    "Bacterial Gill",
    "EUS",
    "Redspot",
    "Tail And Fin Rot"
  ];

  List<File> _images = [];
  List<String> _labels = [];

  final Map<String, List<String>> _medicineRecommendations = {
    "Aeromoniasis": ["Oxytetracycline", "Florfenicol"],
    "Argulus": ["Praziquante", "Dimilin"],
    "Bacterial Gill": ["Kanamycin", "Nitrofurazone"],
    "EUS": ["Formalin", "Potassium Permanganate"],
    "Redspot": ["Kanamycin", "Nitrofurazone"],
    "Tail And Fin Rot": ["Nitrofurazone", "Furan-2"]
  };

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/converted_model.tflite');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> resizeAndPreprocessImage(
      File imageFile, int width, int height) async {
    try {
      Uint8List imageBytes = await imageFile.readAsBytes();
      img_lib.Image image = img_lib.decodeImage(imageBytes)!;
      img_lib.Image resizedImage =
          img_lib.copyResize(image, width: width, height: height);
      Uint8List resizedBytes = img_lib.encodePng(resizedImage);
      classifyImage(resizedBytes);
    } catch (error) {
      print('Error resizing and preprocessing image: $error');
    }
  }

  void classifyImage(Uint8List imageBytes) {
    try {
      final resizedImage = img_lib.decodeImage(imageBytes)!;
      final inputImage =
          img_lib.copyResize(resizedImage, width: 224, height: 224);
      final inputBuffer = Float32List(224 * 224 * 3);

      for (var i = 0; i < 224; i++) {
        for (var j = 0; j < 224; j++) {
          var pixel = inputImage.getPixel(j, i);
          inputBuffer[i * 224 * 3 + j * 3 + 0] =
              ((pixel.r.toDouble() - 127.5) / 127.5).toDouble();
          inputBuffer[i * 224 * 3 + j * 3 + 1] =
              ((pixel.g.toDouble() - 127.5) / 127.5).toDouble();
          inputBuffer[i * 224 * 3 + j * 3 + 2] =
              ((pixel.b.toDouble() - 127.5) / 127.5).toDouble();
        }
      }

      final outputBuffer = Float32List(1 * 6);
      _interpreter.run(
          inputBuffer.buffer.asUint8List(), outputBuffer.buffer.asUint8List());
      final double maxConfidence = outputBuffer.reduce((a, b) => a > b ? a : b);
      final int index = outputBuffer.indexOf(maxConfidence);

      setState(() {
        String label = _classNames[index];
        _labels.add(label);
      });
    } catch (e) {
      print('Error classifying image: $e');
    }
  }

  Future<void> _captureImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      final File capturedImage = File(pickedImage.path);
      setState(() {
        _images.add(capturedImage);
      });
      resizeAndPreprocessImage(capturedImage, 224, 224);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Fish Disease Detection',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 224,
                        width: 224,
                        child: Image.file(
                          _images[index],
                          height: 224,
                          width: 224,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Labels: ${_labels[index]}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Medicine Recommendations:',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Column(
                        children: _medicineRecommendations[_labels[index]]
                                ?.map((medicine) => Text(
                                      medicine,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ))
                                .toList() ??
                            [],
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Choose an option'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: Text('Take a picture'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _captureImage(ImageSource.camera);
                                },
                              ),
                              Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: Text('Select from gallery'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _captureImage(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: Text('Capture Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CaptureImg(),
  ));
}
