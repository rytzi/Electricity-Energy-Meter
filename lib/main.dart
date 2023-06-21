import 'package:electricity_energy_meter/ui/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: "XXX",
    appId: "1:634926003640:android:77b31ca58b4836691b4b4d",
    messagingSenderId: "634926003640",
    projectId: "electricity-energy-meter-56b20",
  ),);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Electricity Energy Meter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const HomeScreen(),
    );
  }
}