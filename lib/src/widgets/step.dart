import 'package:flutter/material.dart';

import '../../simple_stepper.dart';

class SimpleStep extends StatelessWidget {
  final StepModel step;

  const SimpleStep(this.step, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (step.image != null)
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: step.image,
              ),
            ),
          Expanded(
            flex: 7,
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: StepContent(step),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
