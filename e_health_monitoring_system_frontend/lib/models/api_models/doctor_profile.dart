import 'package:e_health_monitoring_system_frontend/models/api_models/appointment_type_dto.dart';

class DoctorProfile {
  final String id;
  final String name;
  final String description;
  final String picture;
  final List<String> specializations;
  final List<AppointmentTypeDto> appointments;

  DoctorProfile({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.specializations,
    required this.appointments,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      picture: json['picture'],
      specializations:
          (json['specializations'] as List<dynamic>)
              .map((e) => e['name'] as String)
              .toList(),
      appointments:
          (json['appointmentTypes'] as List<dynamic>)
              .map(
                (e) => AppointmentTypeDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}
