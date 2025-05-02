import 'dart:async';
import 'dart:convert';

import 'package:e_health_monitoring_system_frontend/helpers/auth_manager.dart';
import 'package:e_health_monitoring_system_frontend/models/patient_register.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  static final _instance = RegisterService._init();

  factory RegisterService() {
    return _instance;
  }

  const RegisterService._init();

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

  Future<http.Response> resendConfirmationEmail(String userId) async {
    return http.post(
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId}),
      Uri.parse(
        "${AuthManager.endpoint}/Register/ResendConfirmationEmail?userid=$userId",
      ),
    );
  }
}

enum EmailStatus { confirmed, unconfirmed, internalError }
