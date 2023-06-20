import 'package:electricity_energy_meter/widget/gauges_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


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
                          GaugesWidget(title: 'VRMS', unit: "V", minValue: 0, maxValue: 500,),
                          GaugesWidget(title: 'IRMS', unit: "A", minValue: 0, maxValue: 10,),
                          GaugesWidget(title: 'Power', unit: "W", minValue: 0, maxValue: 50,),
                          GaugesWidget(title: 'KWH', unit: "W", minValue: 0, maxValue: 10,),
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
