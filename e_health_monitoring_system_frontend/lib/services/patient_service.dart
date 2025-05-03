import 'package:e_health_monitoring_system_frontend/helpers/auth_manager.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/patient_profile.dart';
import 'package:http/http.dart' as http;

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
}
