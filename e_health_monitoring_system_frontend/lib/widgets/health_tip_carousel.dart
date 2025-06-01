import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:flutter/material.dart';

class HealthTipsCarousel extends StatefulWidget {
  const HealthTipsCarousel({super.key});

  @override
  State<HealthTipsCarousel> createState() => _HealthTipsCarouselState();
}

class _HealthTipsCarouselState extends State<HealthTipsCarousel> {
  late final PageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = 5000;
    _controller = PageController(initialPage: _currentIndex);
  }

  final List<_HealthTip> tips = [
    _HealthTip(
      title: StringsHelper.exerciseRegularly,
      description: StringsHelper.exerciseRegularlyMessage,
      icon: Icons.fitness_center,
      backgroundColor: Color(0xFFFFF5E5),
      iconColor: Colors.orange,
    ),
    _HealthTip(
      title: StringsHelper.stayHydrated,
      description: StringsHelper.stayHydratedMessage,
      icon: Icons.water_drop_outlined,
      backgroundColor: Color(0xFFE5F1FF),
      iconColor: Colors.blue,
    ),
    _HealthTip(
      title: StringsHelper.eatBalancedMeals,
      description: StringsHelper.eatBalancedMealsMessage,
      icon: Icons.restaurant,
      backgroundColor: Color(0xFFE6F9EF),
      iconColor: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 15, 0),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                height: 130,
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged:
                      (index) => setState(() => _currentIndex = index),
                  itemBuilder: (context, index) {
                    final tip = tips[index % tips.length];
                    return _buildTipCard(tip);
                  },
                ),
              ),
              Positioned(
                top: -10,
                right: 0,
                child: Row(
                  children: [
                    _buildNavButton(Icons.chevron_left, () {
                      _controller.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }),
                    const SizedBox(width: 5),
                    _buildNavButton(Icons.chevron_right, () {
                      _controller.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard(_HealthTip tip) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tip.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: tip.backgroundColor.withAlpha((0.5 * 255).toInt()),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: tip.iconColor.withAlpha((0.1 * 255).toInt()),
            child: Icon(tip.icon, color: tip.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  tip.description,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}

class _HealthTip {
  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  _HealthTip({
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}
