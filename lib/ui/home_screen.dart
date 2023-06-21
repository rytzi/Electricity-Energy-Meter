import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electricity_energy_meter/widget/gauges_widget.dart';
import 'package:flutter/material.dart';
import '../function/firebaseGetter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _db = FirebaseFirestore.instance;
  // Future<List<ESP32Model>> getESP32Details() async {
  //   final snapshot = await _db.collection("ESP32").get();
  //   final ESP32Data = snapshot.docs.map((e) => ESP32Model.fromSnapshot(e)).toList();
  //   return ESP32Data;
  // }
  Future<ESP32Model> getESP32Details() async {
    final snapshot = await _db.collection("ESP32").get();
    final ESP32Data = snapshot.docs.map((e) => ESP32Model.fromSnapshot(e)).single;
    return ESP32Data;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Stack(
        children: [
          Container(
            height: screenSize.height * .45,
            decoration: BoxDecoration(color: Colors.black,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                )),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Electricity Energy Meter",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: .85,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: [
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('ESP32').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                              List<Map<String, dynamic>?>? ESP32Data = snapshot.data?.docs.map((e) => e.data() as Map<String, dynamic>?).toList();
                              double _value = ESP32Data![0]?["VRMS"];

                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                                );
                              }
                              return GaugesWidget(title: 'VRMS', unit: "V", value: _value, minValue: 0, maxValue: 500,);
                            },
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('ESP32').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                              List<Map<String, dynamic>?>? ESP32Data = snapshot.data?.docs.map((e) => e.data() as Map<String, dynamic>?).toList();
                              double _value = ESP32Data![0]?["IRMS"];

                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                                );
                              }
                              return GaugesWidget(title: 'IRMS', unit: "A", value: _value, minValue: 0, maxValue: 10,);
                            },
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('ESP32').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                              List<Map<String, dynamic>?>? ESP32Data = snapshot.data?.docs.map((e) => e.data() as Map<String, dynamic>?).toList();
                              double _value = ESP32Data![0]?["Power"];

                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                                );
                              }
                              return GaugesWidget(title: 'Power', unit: "W", value: _value, minValue: 0, maxValue: 50,);
                            },
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('ESP32').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                              List<Map<String, dynamic>?>? ESP32Data = snapshot.data?.docs.map((e) => e.data() as Map<String, dynamic>?).toList();
                              double _value = ESP32Data![0]?["KWH"];

                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                                );
                              }
                              return GaugesWidget(title: 'KWH', unit: "W", value: _value, minValue: 0, maxValue: 10,);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
