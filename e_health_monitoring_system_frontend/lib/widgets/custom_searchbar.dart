import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:flutter/material.dart';

class CustomSearchbar extends StatelessWidget {
  final String searchPlaceholder;
  final void Function(String) onChanged;
  final TextEditingController searchController;
  const CustomSearchbar({
    super.key,
    required this.onChanged,
    required this.searchController,
    required this.searchPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(20, 17, 20, 17),
        hintText: searchPlaceholder,
        hintStyle: TextStyle(color: ColorsHelper.mediumGray, fontSize: 14),
        fillColor: ColorsHelper.lightGray,
        filled: true,
        suffixIcon: const Icon(
          Icons.search,
          size: 24,
          color: ColorsHelper.darkGray,
        ),
        suffixIconColor: ColorsHelper.darkGray,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorsHelper.mediumGray),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorsHelper.mediumGray),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
    );
  }
}
