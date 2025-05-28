import 'package:e_health_monitoring_system_frontend/models/patient_profile.dart';
import 'package:e_health_monitoring_system_frontend/screens/appointments/appointments_screen.dart';
import 'package:e_health_monitoring_system_frontend/helpers/auth_manager.dart';
import 'package:e_health_monitoring_system_frontend/screens/home_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/ai_chat_support_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/onboarding_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/sign_in_screen.dart';
import 'package:e_health_monitoring_system_frontend/services/patient_service.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_bottom_tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  final int? bottomNavigatorIndex;
  const MainScreen({super.key, this.bottomNavigatorIndex});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  Widget _getBody(int index, PatientProfile profile) {
    switch (index) {
      case 0:
        return ChatSupportScreen();
      case 1:
        return HomeScreen(patientProfile: profile);
      case 2:
        return AppointmentsScreen();
    }

    return Container();
  }

  Future<PatientProfile?> _getPatientProfile() async {
    var manager = AuthManager();
    if (await manager.isLoggedIn()) {
      return await PatientService().getPatientProfile();
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.bottomNavigatorIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(bottomNavigatorIndex.notifier).state =
            widget.bottomNavigatorIndex!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = ref.watch(bottomNavigatorIndex);
    return FutureBuilder(
      future: _getPatientProfile(),
      // TODO: transition is too fast should show spinner until check is done
      builder: (context, data) {
        if (!data.hasData || data.data == null) {
          return SignInScreen();
        } else {
          return Scaffold(
            extendBody: true,
            bottomNavigationBar: const CustomBottomTabNavigator(),
            body: _getBody(selectedIndex, data.data!),
          );
        }
      },
    );
  }
}
