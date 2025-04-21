class PatientRegister {
  final String email;
  final String passwd;

  PatientRegister({required this.email, required this.passwd});

  Map<String, dynamic> toJson() {
    return {"email": email, "passwd": passwd};
  }
}
