import 'dart:convert';
import 'package:e_health_monitoring_system_frontend/helpers/auth_manager.dart';
import 'package:e_health_monitoring_system_frontend/models/specialization_dto.dart';
import 'package:http/http.dart' as http;

class SpecializationService {
  static Future<List<SpecializationDto>> getAllSpecializations() async {
    final response = await http.get(
      Uri.parse('${AuthManager.endpoint}/Specialization/GetAll'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SpecializationDto.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load specializations');
    }
  }
}
