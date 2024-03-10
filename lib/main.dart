// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:fis/pages/fish_detection.dart';
import 'package:fis/pages/sensor_page.dart';
import './main_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'context/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MALSYA RAKSHAK",
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: MainLayout(), // No child parameter needed here
    );
  }
}
