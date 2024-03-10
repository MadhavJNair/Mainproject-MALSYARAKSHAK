import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fis/pages/login.dart'; // Import the login page

void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the currently logged-in user
    User? user = FirebaseAuth.instance.currentUser;

    // If user is not logged in, redirect to login page
    if (user == null) {
      return MyApp(); // Redirect to the login page
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar icon
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/user.png'), 
              backgroundColor: Colors.white, // Set background color for default icon
            ),
            SizedBox(height: 16),
            // Display user's name
            Text(
              user.displayName ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            // Display user's email
            Text(
              user.email ?? '',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                // Implement logout functionality here
                await FirebaseAuth.instance.signOut(); // Sign out the user
                Navigator.pushReplacement( // Redirect to the homepage
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
