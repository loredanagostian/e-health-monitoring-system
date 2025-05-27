import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctor_profile.dart';
import 'package:e_health_monitoring_system_frontend/helpers/auth_manager.dart';

class DoctorService {
  static Future<List<DoctorProfile>> getAllDoctors() async {
    final response = await http
        .get(Uri.parse("${AuthManager.endpoint}/Doctor/GetAll"))
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => DoctorProfile.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  static Future<List<DoctorProfile>> getDoctorsBySpecialization(
    String specializationId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '${AuthManager.endpoint}/Doctor/GetAllBySpecialization/$specializationId',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => DoctorProfile.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load doctors for specialization');
    }
  }
}
