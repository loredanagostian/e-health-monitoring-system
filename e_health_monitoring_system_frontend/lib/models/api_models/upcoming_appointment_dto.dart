class UpcomingAppointmentDto {
  final String id;
  final int totalCost;
  final String date;
  final String appointmentType;
  final String doctorName;
  final String doctorPicture;

  UpcomingAppointmentDto({
    required this.id,
    required this.totalCost,
    required this.doctorName,
    required this.date,
    required this.appointmentType,
    required this.doctorPicture,
  });

  factory UpcomingAppointmentDto.fromJson(Map<String, dynamic> json) {
    return UpcomingAppointmentDto(
      id: json['id'] as String,
      totalCost: json['totalCost'] as int,
      date: json['date'] as String,
      appointmentType: json['appointmentType'] as String,
      doctorName: json['doctorName'] as String,
      doctorPicture: json['doctorPicture'] as String,
    );
  }
}
