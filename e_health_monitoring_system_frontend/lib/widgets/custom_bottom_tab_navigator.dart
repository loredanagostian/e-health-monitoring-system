import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavigatorIndex = StateProvider<int>((ref) => 1);

class CustomBottomTabNavigator extends ConsumerStatefulWidget {
  const CustomBottomTabNavigator({super.key});

  @override
  ConsumerState<CustomBottomTabNavigator> createState() =>
      _CustomBottomTabNavigatorState();
}

class _CustomBottomTabNavigatorState
    extends ConsumerState<CustomBottomTabNavigator> {
  void _onItemTapped(int index) {
    ref.read(bottomNavigatorIndex.notifier).update((state) => index);
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = ref.watch(bottomNavigatorIndex);

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 228, 228, 228),
            spreadRadius: 0,
            blurRadius: 3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: ColorsHelper.mainWhite,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.support_agent_outlined),
              activeIcon: Icon(Icons.support_agent),
              label: StringsHelper.support,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: StringsHelper.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              activeIcon: Icon(Icons.event_note),
              label: StringsHelper.appointments,
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: ColorsHelper.mainDark,
          selectedLabelStyle: TextStyle(
            color: ColorsHelper.mainDark,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          unselectedItemColor: ColorsHelper.mediumGray,
          unselectedLabelStyle: TextStyle(
            color: ColorsHelper.mediumGray,
            fontSize: 10,
            fontWeight: FontWeight.normal,
          ),
          iconSize: 28,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
