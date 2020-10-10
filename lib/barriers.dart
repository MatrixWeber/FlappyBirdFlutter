import 'package:flutter/material.dart';

class Barriers extends StatelessWidget {
  final double height;
  final double width;

  const Barriers({Key key, this.height, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(width: 10, color: Colors.green[800]),
          borderRadius: BorderRadius.circular(15)),
    );
  }
}
