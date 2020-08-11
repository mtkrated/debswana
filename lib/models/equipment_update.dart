import 'dart:convert';

List<EquipmentUpdate> equipmentFromJson(String str) =>
    List<EquipmentUpdate>.from(
        json.decode(str).map((x) => EquipmentUpdate.fromJson(x)));

String equipmentToJson(List<EquipmentUpdate> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EquipmentUpdate {
  int id;
  String equipment;
  double equipmentAvailability;
  double equipmentUtilization;
  double engineeringAvailability;
  String comments;
  String date;
  String shift;

  EquipmentUpdate(
      {this.id,
      this.equipmentAvailability,
      this.equipmentUtilization,
      this.engineeringAvailability,
      this.equipment,
      this.comments,
      this.date,
      this.shift});

  factory EquipmentUpdate.fromJson(Map<String, dynamic> json) =>
      EquipmentUpdate(
        id: json["id"],
        equipment: json["equipment"],
        equipmentAvailability:
            (json["equipment_availability"] as num).toDouble(),
        equipmentUtilization: (json["equipment_utilization"] as num).toDouble(),
        engineeringAvailability:
            (json["engineering_availability"] as num).toDouble(),
        comments: json["comments"],
        date: json["date"],
        shift: json["shift"],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'equipment': equipment,
      'equipment_availability': equipmentAvailability,
      'equipment_utilization': equipmentUtilization,
      'engineering_availability': engineeringAvailability,
      'date': date,
      'comments': comments,
      'shift': shift,
    };
  }
}
