import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RealtimeDataPage(),
    );
  }
}

class RealtimeDataPage extends StatefulWidget {
  @override
  _RealtimeDataPageState createState() => _RealtimeDataPageState();
}

class _RealtimeDataPageState extends State<RealtimeDataPage> {
  late DatabaseReference _phReference;
  String _phValue = "N/A";
  double _sliderValue = 0.0;
  double _maxSliderValue = 14.0; // Updated maximum value for the circular slider

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      _phReference = FirebaseDatabase.instance.reference().child('pHValue');

      _phReference.onValue.listen((event) {
        final dynamic value = event.snapshot.value;
        if (value != null && (value is double || value is int)) {
          setState(() {
            _phValue = value.toString();
            _sliderValue = value.toDouble(); // Update _sliderValue with pH value
          });

          // Check if pH value is above 9 or under 6
          if (_sliderValue > 9 || _sliderValue < 6) {
            _showPhAlert(); // Show alert
          }
        } else {
          setState(() {
            _phValue = "N/A";
          });
          print('pHValue is not a valid number: $value');
        }
      });
    } catch (e) {
      print('Error initializing Firebase: $e');
      setState(() {
        _phValue = "N/A";
      });
    }
  }

  Color _getColorForPHLevel(double phLevel) {
    if (phLevel < 7) {
      return Colors.red[400]!;
    } else if (phLevel > 7) {
      return Colors.blue[400]!;
    } else {
      return Colors.green[400]!;
    }
  }

  // Function to show alert
  void _showPhAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('pH value is outside the acceptable range.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Real-time Data', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "pH Reading: $_phValue",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                size: 300,
                customColors: CustomSliderColors(
                  trackColor: Colors.grey[800]!,
                  progressBarColor: _getColorForPHLevel(_sliderValue),
                ),
                infoProperties: InfoProperties(
                  mainLabelStyle: TextStyle(color: Colors.white, fontSize: 30),
                  topLabelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  topLabelText: "pH",
                  modifier: (percentage) => (_phValue),
                ),
              ),
              initialValue: _sliderValue,
              max: 14, // Set maximum value for the circular slider
              onChangeEnd: null,
            ),
          ],
        ),
      ),
    );
  }
}
