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
  late DatabaseReference _temperatureReference;
  late DatabaseReference _phReference;
  String _temperatureValue = "N/A";
  String _phValue = "N/A";
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      _temperatureReference = FirebaseDatabase.instance.reference().child('TemperatureValue');
      _phReference = FirebaseDatabase.instance.reference().child('pHValue');

      _temperatureReference.onValue.listen((event) {
        final dynamic value = event.snapshot.value;
        if (value != null && (value is double || value is int)) {
          setState(() {
            _temperatureValue = value.toString();
            _sliderValue = value.toDouble();
          });
        } else {
          setState(() {
            _temperatureValue = "N/A";
          });
          print('TemperatureValue is not a valid number: $value');
        }
      });

      _phReference.onValue.listen((event) {
        final dynamic value = event.snapshot.value;
        if (value != null && (value is double || value is int)) {
          setState(() {
            _phValue = value.toString();
            _sliderValue = value.toDouble(); // Update _sliderValue with pH value
          });
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
        _temperatureValue = "N/A";
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5),
              child: Text("Temperature Reading:", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                infoProperties: InfoProperties(
                  mainLabelStyle: TextStyle(color: Colors.white),
                  topLabelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  topLabelText: "Temp",
                  modifier: (percentage) => (_temperatureValue),
                ),
                customColors: CustomSliderColors(
                  trackColors: [Color.fromARGB(255, 246, 87, 43),
                    Color.fromARGB(255, 78, 203, 245),
                    Color.fromARGB(255, 3, 135, 250)],
                  progressBarColors: [
                    Color.fromARGB(255, 246, 87, 43),
                    Color.fromARGB(255, 78, 203, 245),
                    Color.fromARGB(255, 3, 135, 250)
                  ],
                ),
              ),
              initialValue: double.parse(_temperatureValue),
              onChangeEnd: null,
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text("pH Reading: $_sliderValue" , style: TextStyle(color: Colors.white))
            ),
            
            SizedBox(height: 20),
            SliderTheme(
              
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _getColorForPHLevel(_sliderValue),
                inactiveTrackColor: Colors.red[100],
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 5.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                overlayColor: Color.fromARGB(255, 66, 181, 216).withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                inactiveTickMarkColor: Color.fromARGB(255, 20, 11, 12),
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Color.fromARGB(118, 62, 163, 200),
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
                // valueIndicatorFormatter: (value) => 'pH: $_phValue',
                
                showValueIndicator: ShowValueIndicator.always, // Show value indicator always
              ),
              child: Slider(
                value: _sliderValue,
                onChanged: (newValue) {
                  // Optional: You can add logic here to handle slider value change
                },
                min: 0,
                max: 14,
                divisions: 14,
                label: _sliderValue.round().toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
