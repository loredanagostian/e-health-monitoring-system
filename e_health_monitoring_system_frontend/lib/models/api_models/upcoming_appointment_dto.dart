class AppointmentDto {
  final String id;
  final int totalCost;
  final String date;
  final String appointmentType;
  final String doctorName;
  final String doctorPicture;
  final String doctorId;
  final String medicalHistory;

  AppointmentDto({
    required this.id,
    required this.totalCost,
    required this.doctorName,
    required this.date,
    required this.appointmentType,
    required this.doctorPicture,
    required this.doctorId,
    required this.medicalHistory,
  });

  factory AppointmentDto.fromJson(Map<String, dynamic> json) {
    return AppointmentDto(
      id: json['id'] as String,
      totalCost: json['totalCost'] as int,
      date: json['date'] as String,
      appointmentType: json['appointmentType'] as String,
      doctorName: json['doctorName'] as String,
      doctorPicture: json['doctorPicture'] as String,
      doctorId: json['doctorId'] as String? ?? "",
      medicalHistory: json['medicalHistory'] as String? ?? "",
    );
  }
}
