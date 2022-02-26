import 'package:brick_wall/homeScreen.dart';
import 'package:flutter/material.dart';

class BallContainer extends StatelessWidget {
  const BallContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ballHeight,
      width: ballWidth,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    );
  }
}
