import 'package:flutter/material.dart';

class PasswdTextField extends StatefulWidget {
  const PasswdTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon = Icons.lock_outline,
    this.validator,
  });
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String? value)? validator;

  @override
  State<PasswdTextField> createState() => _PasswdTextFieldState();
}

class _PasswdTextFieldState extends State<PasswdTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(widget.prefixIcon),
        border: OutlineInputBorder(),
        hintText: widget.hintText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
      obscureText: _obscureText,
      autocorrect: false,
      controller: widget.controller,
      validator: _validatePassword,
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is mandatory.";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters.";
    }

    var chars = value.characters;
    var hasNumbers = chars.any((c) => num.tryParse(c) != null);
    if (!hasNumbers) {
      return "Password must have at least one digit.";
    }

    var hasUppercase = value.characters.any((c) => c.toUpperCase() == c);
    if (!hasUppercase) {
      return "Password must have at least one uppercase letter.";
    }

    var isAlphanumeric = RegExp("^[a-zA-Z0-9]+\$").hasMatch(value);
    if (isAlphanumeric) {
      return "Password must have at least one non alphanumeric character.";
    }

    if (widget.validator != null) {
      return widget.validator!(value);
    } else {
      return null;
    }
  }
}
