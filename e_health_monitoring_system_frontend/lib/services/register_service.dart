import 'dart:async';

import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/patient_register.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  const RegisterService();

  Future<http.Response> signUpPatient(PatientRegister patient) async {
    return http
        .post(
          headers: {"Content-Type": "application/json"},
          Uri.parse("${AuthManager.endpoint}/Register/SignUpPatient"),
          body: patient.toJson(),
        )
        .timeout(Duration(seconds: 10));
  }

  Future<http.Response> singInPatient(PatientRegister patient) async {
    return http
        .post(
          headers: {"Content-Type": "application/json"},
          Uri.parse("${AuthManager.endpoint}/Register/SignInPatient"),
          body: patient.toJson(),
        )
        .timeout(Duration(seconds: 10));
  }

  Future<http.Response> checkEmailConfirmed(String userId) async {
    var future = http.post(
      headers: {"Content-Type": "application/json"},
      Uri.parse(
        "${AuthManager.endpoint}/Register/CheckEmailStatus?userid=$userId",
      ),
    );

    return future;
  }
}

enum EmailStatus { confirmed, unconfirmed, internalError }
