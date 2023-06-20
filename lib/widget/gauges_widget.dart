import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gauges/gauges.dart';

class GaugesWidget extends StatefulWidget {
  final String title;
  final String unit;
  final double minValue;
  final double maxValue;


  const GaugesWidget(
      {Key? key,
      required this.title,
      required this.unit,
      required this.minValue,
      required this.maxValue})
      : super(key: key);

  @override
  State<GaugesWidget> createState() => _GaugesWidgetState();

}

class _GaugesWidgetState extends State<GaugesWidget> {
  //TODO: Remove value
  double value = 8;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 16),
            blurRadius: 20,
            spreadRadius: -20,
            color: Colors.black,
          ),
        ],
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('data').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Spacer(),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
              RadialGauge(
                axes: [
                  RadialGaugeAxis(
                    color: Colors.white,
                    minValue: widget.minValue,
                    maxValue: widget.maxValue,
                    minAngle: -150,
                    maxAngle: 150,
                    radius: 0.6,
                    width: 0.2,
                    ticks: [
                      RadialTicks(
                          interval: widget.maxValue * 0.1,
                          alignment: RadialTickAxisAlignment.below,
                          color: Colors.black,
                          length: 0.02,
                          children: [
                            RadialTicks(
                                ticksInBetween: 5,
                                length: 0.1,
                                color: Colors.grey),
                          ])
                    ],
                    pointers: [
                      RadialNeedlePointer(
                        // TODO: Get firebase value
                        value: value,
                        thicknessStart: 20,
                        thicknessEnd: 0,
                        length: 0.6,
                        knobRadiusAbsolute: 10,
                      )
                    ],
                    segments: [
                      RadialGaugeSegment(
                        minValue: widget.minValue,
                        maxValue: widget.maxValue * .20,
                        minAngle: -150,
                        maxAngle: -90,
                        color: Colors.green,
                      ),
                      RadialGaugeSegment(
                        minValue: widget.maxValue * .20,
                        maxValue: widget.maxValue * .40,
                        minAngle: -90,
                        maxAngle: -30,
                        color: Colors.lightGreen,
                      ),
                      RadialGaugeSegment(
                        minValue: widget.maxValue * .40,
                        maxValue: widget.maxValue * .60,
                        minAngle: -30,
                        maxAngle: 30,
                        color: Colors.yellow,
                      ),
                      RadialGaugeSegment(
                          minValue: widget.maxValue * .60,
                          maxValue: widget.maxValue * .80,
                          minAngle: 30,
                          maxAngle: 90,
                          color: Colors.orangeAccent),
                      RadialGaugeSegment(
                        minValue: widget.maxValue * .80,
                        maxValue: widget.maxValue,
                        minAngle: 90,
                        maxAngle: 150,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                //TODO:change value
                value.toString() + widget.unit,
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
              Spacer(),
            ],
          );
        },
      ),
    );
  }
}
