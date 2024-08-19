import 'package:flutter/material.dart';

import '../../simple_stepper.dart';

class StepContent extends StatelessWidget {
  final StepModel step;

  const StepContent(this.step, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: step.alignment,
        children: [
          step.titleWidget != null
              ? step.titleWidget!
              : Text(
                  step.title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(87, 57, 48, 1),
                  ),
                ),
          step.bodyWidget != null
              ? step.bodyWidget!
              : Text(
                  step.body!,
                  style: const TextStyle(fontSize: 15),
                ),
        ],
      ),
    );
  }
}
