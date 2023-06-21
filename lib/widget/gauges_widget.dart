import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:gauges/gauges.dart';

class GaugesWidget extends StatefulWidget {
  final String title;
  final String unit;
  final double minValue;
  final double maxValue;
  final double value;
  final Size screenSize;

  const GaugesWidget(
      {Key? key,
      required this.title,
      required this.unit,
      required this.minValue,
      required this.maxValue,
      required this.value,
      required this.screenSize})
      : super(key: key);

  @override
  State<GaugesWidget> createState() => _GaugesWidgetState();
}

class _GaugesWidgetState extends State<GaugesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: widget.screenSize.width * 0.03,
          horizontal: widget.screenSize.height * 0.03),
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
      child: SfRadialGauge(
          animationDuration: 10,
          title: GaugeTitle(
              text: widget.title,
              textStyle:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          axes: <RadialAxis>[
            RadialAxis(
                minimum: widget.minValue,
                maximum: widget.maxValue,
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Container(
                          child: Text(widget.value.toString() + widget.unit.toString(),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold))),
                      angle: 90,
                      positionFactor: 1)
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: widget.value,
                    enableAnimation: true,
                  )
                ],
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: widget.minValue,
                      endValue: widget.maxValue * .2,
                      color: Colors.green,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: widget.maxValue * .2,
                      endValue: widget.maxValue * .4,
                      color: Colors.lightGreen,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: widget.maxValue * .4,
                      endValue: widget.maxValue * .6,
                      color: Colors.yellow,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: widget.maxValue * .6,
                      endValue: widget.maxValue * .8,
                      color: Colors.orangeAccent,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: widget.maxValue * .8,
                      endValue: widget.maxValue,
                      color: Colors.red,
                      startWidth: 10,
                      endWidth: 10),
                ])
          ]),
      // Column(
      //   children: [
      //     Spacer(),
      // Text(
      //   widget.title,
      //   textAlign: TextAlign.center,
      //   style: TextStyle(fontStyle: FontStyle.normal),
      // ),
      // RadialGauge(
      //   axes: [
      //     RadialGaugeAxis(
      //       color: Colors.white,
      //       minValue: widget.minValue,
      //       maxValue: widget.maxValue,
      //       minAngle: -150,
      //       maxAngle: 150,
      //       radius: 0.6,
      //       width: 0.2,
      //       ticks: [
      //         RadialTicks(
      //             interval: widget.maxValue * 0.1,
      //             alignment: RadialTickAxisAlignment.below,
      //             color: Colors.black,
      //             length: 0.02,
      //             children: [
      //               RadialTicks(
      //                   ticksInBetween: 5,
      //                   length: 0.1,
      //                   color: Colors.grey),
      //             ])
      //       ],
      //       pointers: [
      //         RadialNeedlePointer(
      //           value: widget.value,
      //           thicknessStart: 20,
      //           thicknessEnd: 0,
      //           length: 0.6,
      //           knobRadiusAbsolute: 10,
      //         )
      //       ],
      //       segments: [
      //         RadialGaugeSegment(
      //           minValue: widget.minValue,
      //           maxValue: widget.maxValue * .20,
      //           minAngle: -150,
      //           maxAngle: -90,
      //           color: Colors.green,
      //         ),
      //         RadialGaugeSegment(
      //           minValue: widget.maxValue * .20,
      //           maxValue: widget.maxValue * .40,
      //           minAngle: -90,
      //           maxAngle: -30,
      //           color: Colors.lightGreen,
      //         ),
      //         RadialGaugeSegment(
      //           minValue: widget.maxValue * .40,
      //           maxValue: widget.maxValue * .60,
      //           minAngle: -30,
      //           maxAngle: 30,
      //           color: Colors.yellow,
      //         ),
      //         RadialGaugeSegment(
      //             minValue: widget.maxValue * .60,
      //             maxValue: widget.maxValue * .80,
      //             minAngle: 30,
      //             maxAngle: 90,
      //             color: Colors.orangeAccent),
      //         RadialGaugeSegment(
      //           minValue: widget.maxValue * .80,
      //           maxValue: widget.maxValue,
      //           minAngle: 90,
      //           maxAngle: 150,
      //           color: Colors.red,
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      // Text(
      //   widget.value.toString() + widget.unit,
      //   textAlign: TextAlign.center,
      //   style: TextStyle(fontStyle: FontStyle.normal),
      //     // ),
      //     Spacer(),
      //   ],
      // )
    );
  }
}
