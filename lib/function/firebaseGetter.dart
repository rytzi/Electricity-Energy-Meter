import 'package:cloud_firestore/cloud_firestore.dart';

class ESP32Model {
  final String id;
  final double VRMS;
  final double IRMS;
  final double Power;
  final double KWH;

  const ESP32Model({
    required this.id,
    required this.VRMS,
    required this.IRMS,
    required this.Power,
    required this.KWH,});

  toJson() {
    return {"VRMS": VRMS, "IRMS": IRMS, "Power": Power, "KWH": KWH};
  }

  factory ESP32Model.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return ESP32Model(id: document.id, VRMS: data?["VRMS"], IRMS: data?["IRMS"], Power: data?["Power"], KWH: data?["KWH"],);
  }
}