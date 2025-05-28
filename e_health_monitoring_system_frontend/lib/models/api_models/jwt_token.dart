import 'dart:convert';

import 'package:jwt_decode/jwt_decode.dart';

class JwtToken {
  final String accessToken;
  final String refreshToken;

  JwtToken(this.accessToken, this.refreshToken);

  JwtToken.fromJson(Map<String, dynamic> json)
    : accessToken = json['accessToken'],
      refreshToken = json['refreshToken'];

  String toJson() {
    return jsonEncode({
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    });
  }

  bool isExpired() {
    return Jwt.isExpired(accessToken);
  }
}
