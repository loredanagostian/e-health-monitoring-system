import 'dart:convert';

class PatientProfile {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String cnp;

  PatientProfile({
    required this.lastName,
    required this.phoneNumber,
    required this.cnp,
    required this.firstName,
  });

  String toJson() {
    return jsonEncode({
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "cnp": cnp,
    });
  }

  factory PatientProfile.fromJson(String json) {
    var map = jsonDecode(json);
    return PatientProfile(
      firstName: map['firstName'],
      lastName: map['lastName'],
      cnp: map['cnp'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
