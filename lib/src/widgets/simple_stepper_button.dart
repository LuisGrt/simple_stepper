import 'package:flutter/cupertino.dart';

class SimpleStepperButton extends StatelessWidget {
  final int flex;
  final double opacity;
  final VoidCallback? onPressed;
  final Widget? child;

  const SimpleStepperButton(
    this.child, {
    this.flex = 0,
    this.opacity = 1.0,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Opacity(
        opacity: opacity,
        child: SizedBox(
          width: 80,
          child: child != null
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: onPressed,
                  child: child!,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
