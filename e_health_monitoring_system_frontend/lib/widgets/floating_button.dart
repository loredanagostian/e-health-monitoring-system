import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final List<Widget> children;
  final void Function() onPressed;
  final String label;

  const FloatingButton({
    required this.onPressed,
    required this.label,
    this.children = const <Widget>[],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(onPressed: onPressed, text: label),
          ...children,
        ],
      ),
    );
  }
}
