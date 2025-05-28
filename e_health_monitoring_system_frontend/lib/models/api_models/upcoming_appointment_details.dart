class AppointmentDetails {
  final String id;
  final String date;
  final String appointmentType;
  final String doctorName;
  final String doctorPicture;
  final String medicalHistory;
  final String diagnostic;
  final String recommendation;
  final int totalCost;

  AppointmentDetails({
    required this.id,
    required this.totalCost,
    required this.doctorName,
    required this.date,
    required this.appointmentType,
    required this.doctorPicture,
    required this.medicalHistory,
    required this.diagnostic,
    required this.recommendation,
  });

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    return AppointmentDetails(
      id: json['id'] as String,
      totalCost: json['totalCost'] as int,
      date: json['date'] as String,
      appointmentType: json['appointmentType'] as String,
      doctorName: json['doctorName'] as String,
      doctorPicture: json['doctorPicture'] as String? ?? "",
      medicalHistory: json['medicalHistory'] as String? ?? "",
      diagnostic: json['diagnostic'] as String? ?? "",
      recommendation: json['recommendation'] as String? ?? "",
    );
  }
}
