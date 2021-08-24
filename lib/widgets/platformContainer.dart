import 'package:flutter/material.dart';

class PlatformContainer extends StatelessWidget {
  final double width;
  const PlatformContainer({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(10.0)),
    );
  }
}
