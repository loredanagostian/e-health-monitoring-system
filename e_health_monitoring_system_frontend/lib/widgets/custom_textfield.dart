import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:flutter/material.dart';

enum TextFieldType {
  email,
  password,
  confirmPassword,
  firstName,
  lastName,
  phoneNumber,
  cnp,
}

class CustomTextField extends StatefulWidget {
  final TextFieldType textFieldType;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.textFieldType,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isVisible = true;
  bool isPasswordField = false;

  @override
  void initState() {
    super.initState();

    isPasswordField =
        widget.textFieldType == TextFieldType.password ||
        widget.textFieldType == TextFieldType.confirmPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: ColorsHelper.lightGray,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsHelper.mediumGray),
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: isPasswordField ? isVisible : false,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(color: ColorsHelper.mainDark, fontSize: 14),
          decoration: InputDecoration(
            hintText: getPlaceholderText(),
            hintStyle: TextStyle(
              color: ColorsHelper.mediumGray,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            prefixIcon: Icon(getPrefixIcon(), color: ColorsHelper.mediumGray),
            suffixIcon:
                getSuffixIcon() != null
                    ? IconButton(
                      icon: Icon(
                        getSuffixIcon(),
                        color: ColorsHelper.mediumGray,
                      ),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    )
                    : null,
          ),
          keyboardType: getKeyboardType(),
        ),
      ),
    );
  }

  String getPlaceholderText() {
    switch (widget.textFieldType) {
      case TextFieldType.email:
        return StringsHelper.enterEmail;
      case TextFieldType.password:
        return StringsHelper.enterPassword;
      case TextFieldType.confirmPassword:
        return StringsHelper.confirmPassword;
      case TextFieldType.firstName:
        return StringsHelper.enterFirstName;
      case TextFieldType.lastName:
        return StringsHelper.enterLastName;
      case TextFieldType.cnp:
        return StringsHelper.enterCnp;
      case TextFieldType.phoneNumber:
        return StringsHelper.enterPhoneNumber;
    }
  }

  TextInputType getKeyboardType() {
    switch (widget.textFieldType) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.password ||
          TextFieldType.confirmPassword ||
          TextFieldType.firstName ||
          TextFieldType.lastName:
        return TextInputType.text;
      case TextFieldType.cnp:
        return TextInputType.number;
      case TextFieldType.phoneNumber:
        return TextInputType.phone;
    }
  }

  IconData getPrefixIcon() {
    switch (widget.textFieldType) {
      case TextFieldType.email:
        return Icons.mail_outline;
      case TextFieldType.password:
        return Icons.lock_outline;
      case TextFieldType.confirmPassword:
        return Icons.check_circle_outline;
      case TextFieldType.firstName || TextFieldType.lastName:
        return Icons.person_outline;
      case TextFieldType.cnp:
        return Icons.assignment_ind_outlined;
      case TextFieldType.phoneNumber:
        return Icons.phone_outlined;
    }
  }

  IconData? getSuffixIcon() {
    switch (widget.textFieldType) {
      case TextFieldType.password || TextFieldType.confirmPassword:
        return isVisible
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined;
      default:
        return null;
    }
  }
}
