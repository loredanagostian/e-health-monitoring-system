import 'dart:convert';
import 'package:e_health_monitoring_system_frontend/models/jwt_token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static final AuthManager _manager = AuthManager._init();
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static JwtToken? _token;
  // TODO: add local env var for ip
  static final String endpoint = "http://10.0.2.2:5200/api";

  Future<JwtToken?> get jwtToken async {
    _token ??= await _loadToken();

    if (_token?.isExpired() ?? false) {
      _token = await _refreshToken(_token!);
      if (_token != null) {
        await saveToken(_token!);
      }
    }
    return _token;
  }

  factory AuthManager() {
    return _manager;
  }

  AuthManager._init();

  Future<void> saveToken(JwtToken token) async {
    await _secureStorage.write(key: "accessToken", value: token.accessToken);
    await _secureStorage.write(key: "refreshToken", value: token.refreshToken);
    await _prefs.setBool("isLoggedIn", true);
  }

  Future<JwtToken?> _loadToken() async {
    var accessToken = await _secureStorage.read(key: "accessToken");
    var refreshToken = await _secureStorage.read(key: "refreshToken");
    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return JwtToken(accessToken, refreshToken);
  }

  Future<JwtToken?> _refreshToken(JwtToken crtToken) async {
    var resp = await http
        .post(
          headers: {"Content-Type": "application/json"},
          Uri.parse("${AuthManager.endpoint}/Register/RefreshToken"),
          body: crtToken.toJson(),
        )
        .timeout(Duration(seconds: 10));

    if (resp.statusCode == 200) {
      return JwtToken.fromJson(jsonDecode(resp.body)["token"]);
    }

    return null;
  }

  Future<bool> isLoggedIn() async {
    return await _prefs.getBool("isLoggedIn") ?? false;
  }
}
