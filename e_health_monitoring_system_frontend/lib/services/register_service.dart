import 'dart:async';

import 'package:e_health_monitoring_system_frontend/models/patient_register.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  // TODO: add local env var for ip
  final String endpoint = "http://10.0.2.2:5200/api/Register";
  const RegisterService();

  Future<http.Response> signUpPatient(PatientRegister patient) async {
    return http
        .post(
          headers: {"Content-Type": "application/json"},
          Uri.parse("$endpoint/SignUpPatient"),
          body: patient.toJson(),
        )
        .timeout(Duration(seconds: 10));
  }

  Future<http.Response> singInPatient(PatientRegister patient) async {
    return http
        .post(
          headers: {"Content-Type": "application/json"},
          Uri.parse("$endpoint/SignInPatient"),
          body: patient.toJson(),
        )
        .timeout(Duration(seconds: 10));
  }

  Future<http.Response> checkEmailConfirmed(String userId) async {
    var future = http.post(
      headers: {"Content-Type": "application/json"},
      Uri.parse("$endpoint/CheckEmailStatus?userid=$userId"),
    );

    return future;
  }
}

enum EmailStatus { confirmed, unconfirmed, internalError }
