class AppointmentTypeDto {
  final String id;
  final String name;
  final int price;

  AppointmentTypeDto({
    required this.id,
    required this.name,
    required this.price,
  });

  factory AppointmentTypeDto.fromJson(Map<String, dynamic> json) {
    return AppointmentTypeDto(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
    );
  }
}
