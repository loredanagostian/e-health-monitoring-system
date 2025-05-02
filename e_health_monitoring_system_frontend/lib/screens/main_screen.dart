import 'package:e_health_monitoring_system_frontend/helpers/auth_manager.dart';
import 'package:e_health_monitoring_system_frontend/screens/appointments_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/home_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/onboarding_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/sign_in_screen.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_bottom_tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  Widget _getBody(int index) {
    switch (index) {
      case 0:
      // return ChatSupportScreen();
      case 1:
        return HomeScreen();
      case 2:
        return AppointmentsScreen();
    }

    return HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = ref.watch(bottomNavigatorIndex);
    var manager = AuthManager();
    return FutureBuilder(
      future: manager.isLoggedIn(),
      // TODO: transition is too fast should show spinner until check is done
      builder: (context, data) {
        if (!data.hasData || data.data == false) {
          return SignInScreen();
        } else {
          return Scaffold(
            extendBody: true,
            bottomNavigationBar: const CustomBottomTabNavigator(),
            body: _getBody(selectedIndex),
          );
        }
      },
    );
  }
}
