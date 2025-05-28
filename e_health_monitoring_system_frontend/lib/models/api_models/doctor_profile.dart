class DoctorProfile {
  final String id;
  final String name;
  final String description;
  final String picture;
  final List<String> specializations;

  DoctorProfile({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.specializations,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      picture: json['picture'],
      specializations: (json['specializations'] as List<dynamic>)
          .map((e) => e['name'] as String)
          .toList(),
    );
  }
}
