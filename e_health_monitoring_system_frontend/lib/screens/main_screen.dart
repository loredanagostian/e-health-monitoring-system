import 'package:e_health_monitoring_system_frontend/screens/appointments_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/home_screen.dart';
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

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const CustomBottomTabNavigator(),
      body: _getBody(selectedIndex),
    );
  }
}
