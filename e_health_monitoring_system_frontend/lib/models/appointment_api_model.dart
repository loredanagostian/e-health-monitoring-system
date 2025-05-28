import 'dart:convert';

class AppointmentApiModel {
  final String appointmentTypeId;
  final String date;
  final int totalCost;

  AppointmentApiModel({
    required this.appointmentTypeId,
    required this.date,
    required this.totalCost,
  });

  String toJson() {
    return jsonEncode({
      "appointmentTypeId": appointmentTypeId,
      "date": date,
      "totalCost": totalCost,
    });
  }
}
