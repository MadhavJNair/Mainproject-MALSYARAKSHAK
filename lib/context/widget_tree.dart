// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fis/pages/home_page.dart';
import 'package:fis/pages/sensor_page.dart';
import 'package:fis/pages/test.dart';
import 'package:flutter/material.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return RealtimeDataPage();
          }
          
          else
             return LoginPage();

          
        },
      ),
    );
  }
}