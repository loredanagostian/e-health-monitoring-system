class SpecializationDto {
  final String id;
  final String name;
  final String icon;

  SpecializationDto({required this.id, required this.name, required this.icon});

  factory SpecializationDto.fromJson(Map<String, dynamic> json) {
    return SpecializationDto(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }
}
