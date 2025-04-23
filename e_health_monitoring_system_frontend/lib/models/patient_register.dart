import 'dart:convert';

class PatientRegister {
  final String email;
  final String passwd;

  PatientRegister({required this.email, required this.passwd});

  String toJson() {
    return jsonEncode({"email": email, "passwd": passwd});
  }
}
