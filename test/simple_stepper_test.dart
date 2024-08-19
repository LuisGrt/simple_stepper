import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:developer' as developer;

import 'package:simple_stepper/simple_stepper.dart';

void main() {
  group('Simple Stepper', () {
    const step = StepModel(
      title: 'Test Model',
      body: 'Test body content',
    );

    test('Verify Step Model', () {
      expect(step.alignment, MainAxisAlignment.start);
      expect(step.bodyWidget, null);
      expect(step.titleWidget, null);
    });

    testWidgets('Creates Widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SimpleStepper(
            steps: const [step],
            onDone: () {
              developer.log('Done action triggered');
              return true;
            },
            onCancel: () => developer.log('Cancel action triggered'),
          ),
        ),
      );

      expect(find.text('DONE'), findsOneWidget);
      await tester.tap(find.text('DONE'));

      expect(find.text('CANCEL'), findsOneWidget);
      await tester.tap(find.text('CANCEL'));
    });
  });
}
