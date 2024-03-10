import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      // Preprocess the image to 224x224 resolution
      final processedImage = await preprocessImage(_image!);

      // Pass the processed image to the model
      passImageToModel(processedImage);
    }
  }

  Future<File> preprocessImage(File image) async {
    final bytes = await image.readAsBytes();
    final decodedImage = img.decodeImage(bytes);

    final resizedImage = img.copyResize(decodedImage!, width: 224, height: 224);

    final processedImage = File(image.path);
    await processedImage.writeAsBytes(img.encodePng(resizedImage));

    return processedImage;
  }

  Future<void> passImageToModel(File image) async {
    final imageModel = ImageModel();
    await imageModel.loadModel();

    // Pass the processed image to the model
    final output = await imageModel.processImage(image);
    print(output);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 16, 16),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Camera'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Gallery'),
            ),
            if (_image != null) Image.file(_image!),
          ],
        ),
      ),
    );
  }
}

class ImageModel {
  late Interpreter _interpreter;
  static const int outputSize = 1000; // Change this according to your model output size

  Future<void> loadModel() async {
    final modelFile = await File('assests/converted_model.tflite').readAsBytes();
    _interpreter = await Interpreter.fromBuffer(modelFile);
  }

  Future<List<double>> processImage(File image) async {
    final inputImage = preprocessImage(image);
    final input = inputImage.buffer.asFloat32List();

    final output = List<double>.filled(outputSize, 0);

    _interpreter.run(input, output);

    return output;
  }

  img.Image preprocessImage(File image) {
    final bytes = image.readAsBytesSync();
    final decodedImage = img.decodeImage(bytes);

    // Implement your image preprocessing logic here
    // ...

    return decodedImage!;
  }
}
