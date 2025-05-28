import 'dart:convert';

import 'package:e_health_monitoring_system_frontend/helpers/auth_manager.dart';
import 'package:e_health_monitoring_system_frontend/models/appointment_api_model.dart';
import 'package:http/http.dart' as http;

class AppointmentService {
  static final AuthManager _manager = AuthManager();

  Future<http.Response> createAppointment(
    AppointmentApiModel appointment,
  ) async {
    var token = await _manager.jwtToken;

    return http
        .post(
          Uri.parse("${AuthManager.endpoint}/Appointment/Add"),
          body: appointment.toJson(),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token?.accessToken}",
          },
        )
        .timeout(Duration(seconds: 10));
  }

  Future<List<DateTime>> getBookedTimeSlots(String doctorId) async {
    var token = await _manager.jwtToken;

    var resp = await http
        .get(
          Uri.parse(
            "${AuthManager.endpoint}/Appointment/GetBookedTimeSlots/$doctorId",
          ),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token?.accessToken}",
          },
        )
        .timeout(Duration(seconds: 10));

    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body);
      var timeSlots = body["timeSlots"] as List;
      return timeSlots.map((s) => DateTime.parse(s)).toList();
    } else {
      print("status error");
      return [];
    }
  }
}
