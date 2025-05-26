import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedDots extends StatefulWidget {
  @override
  _AnimatedDotsState createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots> {
  int dotCount = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 500), (_) {
      setState(() {
        dotCount = (dotCount + 1) % 4; // 0 to 3 dots
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '.' * dotCount,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
    );
  }
}