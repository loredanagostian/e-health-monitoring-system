import 'package:e_health_monitoring_system_frontend/helpers/auth_manager.dart';
import 'package:e_health_monitoring_system_frontend/models/api_models/patient_profile.dart';
import 'package:http/http.dart' as http;

class MissingProfileException implements Exception {}

class InvalidAccount implements Exception {}

// TODO: make singleton
class PatientService {
  static final AuthManager _manager = AuthManager();

  const PatientService();

  Future<http.Response> completeProfile(PatientProfile profile) async {
    var token = await _manager.jwtToken;
    return http
        .post(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token?.accessToken}",
          },
          body: profile.toJson(),
          Uri.parse("${AuthManager.endpoint}/Patient/CompleteProfile"),
        )
        .timeout(Duration(seconds: 10));
  }

  Future<PatientProfile?> getPatientProfile() async {
    final token = await AuthManager().jwtToken;

    if (token == null) return null;

    final uri = Uri.parse('${AuthManager.endpoint}/Patient/GetPatientProfile');

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token.accessToken}",
      },
    );

    if (response.statusCode == 200) {
      return PatientProfile.fromJson(response.body);
    } else {
      if (response.statusCode == 400) {
        throw MissingProfileException();
      }

      throw InvalidAccount();
    }
  }

  void updateProfile(PatientProfile profile) {}
}
