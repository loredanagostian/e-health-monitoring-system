import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:flutter/material.dart';

final Map<String, IconData> medicalIcons = {
  StringsHelper.cardiology: Icons.favorite_outline, // heart symbol
  StringsHelper.dentistry:
      Icons.medical_services_outlined, // general medical symbol
  StringsHelper.pediatrics: Icons.child_care_outlined, // child symbol
  StringsHelper.neurology:
      Icons.psychology_outlined, // brain/mental health symbol
  StringsHelper.orthopedics: Icons.accessibility_new_outlined, // human figure
  StringsHelper.ophthalmology: Icons.visibility_outlined, // eye symbol
  StringsHelper.dermatology: Icons.face_outlined, // face/skin symbol
  StringsHelper.radiology: Icons.waves_outlined, // wave/scanning symbol
  StringsHelper.pharmacy: Icons.local_pharmacy_outlined, // pharmacy symbol
  StringsHelper.surgery: Icons.healing_outlined, // bandage/cross symbol
};
