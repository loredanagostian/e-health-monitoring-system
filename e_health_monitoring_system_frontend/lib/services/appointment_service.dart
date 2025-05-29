import 'dart:convert';

import 'package:e_health_monitoring_system_frontend/helpers/auth_manager.dart';
import 'package:e_health_monitoring_system_frontend/models/api_models/upcoming_appointment_details.dart';
import 'package:e_health_monitoring_system_frontend/models/api_models/upcoming_appointment_dto.dart';
import 'package:e_health_monitoring_system_frontend/models/appointment_api_model.dart';
import 'package:e_health_monitoring_system_frontend/widgets/upcoming_appointment.dart';
import 'package:http/http.dart' as http;

class AppointmentService {
  static final AuthManager _manager = AuthManager();

  // TODO: should throw not return null, use option !!
  static Future<AppointmentDetails?> getAppointmentDetails(String id) async {
    var token = await _manager.jwtToken;
    var resp = await http
        .get(
          Uri.parse("${AuthManager.endpoint}/Appointment/GetById/$id"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token?.accessToken}",
          },
        )
        .timeout(Duration(seconds: 10));

    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body) as Map<String, dynamic>;
      var ap = AppointmentDetails.fromJson(body);
      return ap;
    } else {
      return null;
    }
  }

  static Future<http.Response> createAppointment(
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

  static Future<List<DateTime>> getBookedTimeSlots(String doctorId) async {
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

  static Future<List<AppointmentDto>> getUpcomingAppointments() async {
    var token = await _manager.jwtToken;

    var resp = await http
        .get(
          Uri.parse(
            "${AuthManager.endpoint}/Appointment/GetFutureAppointments",
          ),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token?.accessToken}",
          },
        )
        .timeout(Duration(seconds: 10));

    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body);
      var appointments = body as List;
      return appointments.map((a) => AppointmentDto.fromJson(a)).toList();
    } else {
      print("status error");
      return [];
    }
  }

  static Future<List<AppointmentDto>> getPastVisits() async {
    var token = await _manager.jwtToken;

    var resp = await http
        .get(
          Uri.parse("${AuthManager.endpoint}/Appointment/GetPastVisits"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token?.accessToken}",
          },
        )
        .timeout(Duration(seconds: 10));

    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body);
      var appointments = body as List;
      return appointments.map((a) => AppointmentDto.fromJson(a)).toList();
    } else {
      print("status error");
      return [];
    }
  }
}
