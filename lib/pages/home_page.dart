import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  String getGreetingMessage() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text('Home Page'),
      // ),
      body: Center(
        child: Column(
          children: [
            Lottie.network(
              'https://lottie.host/cf85c6e3-c3ad-4062-a875-292bb644a21d/UcjBcOUFSM.json',
              height: 300,
              width: 300,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome!',
              style: TextStyle(fontSize: 24,color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '${getGreetingMessage()}',
              style: TextStyle(fontSize: 20,color: Colors.blue, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
