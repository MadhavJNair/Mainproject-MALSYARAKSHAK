import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(const HomePage());

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          children: <Widget>[
            Lottie.network(
              'https://lottie.host/1d3d589f-7bf2-4ec1-8492-928623e22b9a/WlhofAia3n.json',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20,),
            
            const SizedBox(height: 10,),
          Container(
 // height: 2000, // Adjust the width as needed
  child: Column(
    children: [
      TextField(
        controller: usernameController,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          hintText: 'Username',
          hintStyle: TextStyle(color: Colors.blue),
          fillColor: Colors.black,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
      const SizedBox(height: 10,),
      TextField(
        controller: passwordController,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          hintText: 'Password', 
          hintStyle: TextStyle(color: Colors.blue),
          fillColor: Colors.black,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        obscureText: true,
      ),
    ],
  ),
),

            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => signUserIn(),
                  child: Text('Sign In'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  const SizedBox(width: 4),
                  const Text(
                    'Register now',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
