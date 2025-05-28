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
}
