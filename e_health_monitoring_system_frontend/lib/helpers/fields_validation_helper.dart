import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:flutter/material.dart';

class FieldsValidationHelper {
  static String validatePassword(String password) {
    if (password.isEmpty) return StringsHelper.allFieldsMustBeCompleted;
    if (password.length < 6) return StringsHelper.passwordShouldBeAtLeast6Chars;

    var chars = password.characters;
    var hasNumbers = chars.any((c) => num.tryParse(c) != null);
    if (!hasNumbers) {
      return StringsHelper.passwordShouldContain1Digit;
    }

    var hasUppercase = password.characters.any((c) => c.toUpperCase() == c);
    if (!hasUppercase) {
      return StringsHelper.passwordShouldContain1Upper;
    }

    var isAlphanumeric = RegExp("^[a-zA-Z0-9]+\$").hasMatch(password);
    if (isAlphanumeric) {
      return StringsHelper.passwordShouldContain1NonAlphaNum;
    }

    return "";
  }

  static bool validateEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }
}
