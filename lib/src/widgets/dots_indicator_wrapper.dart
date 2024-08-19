import 'package:flutter/material.dart';

import '../../simple_stepper.dart';

class DotsIndicatorWrapper extends StatelessWidget {
  final int count;
  final double currentPosition;

  const DotsIndicatorWrapper({
    required this.count,
    required this.currentPosition,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: DotsIndicator(
          dotsCount: count,
          position: currentPosition,
          decorator: const DotsDecorator(
            activeSize: Size(22, 10),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            spacing: EdgeInsets.symmetric(horizontal: 2),
          ),
        ),
      ),
    );
  }
}
