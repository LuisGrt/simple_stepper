import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../simple_stepper.dart';

class SimpleStepper extends StatefulWidget {
  final Key? scaffoldKey;
  final List<StepModel> steps;
  final int initialStep;
  final bool scrollable;
  final bool unfocusOnScroll;

  /// Defines if it can scroll to the next step.
  ///
  /// This is ignored if [scrollable] is `true`.
  ///
  ///  Defaults to `true`.
  final bool canProceed;

  /// Defines if it can scroll to the previous step.
  ///
  /// This is ignored if [scrollable] is `true`.
  ///
  /// Defaults to `true`.
  final bool canGoBack;
  final FutureOr<bool> Function()? onPrev;
  final FutureOr<bool> Function()? onNext;
  final FutureOr<bool> Function() onDone;
  final VoidCallback onCancel;
  final Widget onDoneWidget;
  final Widget onCancelWidget;
  final bool displayLeftButton;
  final bool displayRightButton;
  final bool displayNextArrow;
  final bool displayPrevArrow;

  SimpleStepper({
    this.scaffoldKey,
    required this.steps,
    this.initialStep = 0,
    this.scrollable = true,
    this.unfocusOnScroll = true,
    this.canGoBack = true,
    this.canProceed = true,
    this.onPrev,
    this.onNext,
    required this.onCancel,
    required this.onDone,
    this.displayLeftButton = true,
    this.displayRightButton = true,
    this.displayNextArrow = true,
    this.displayPrevArrow = true,
    String? onDoneTitle,
    String? onCancelTitle,
    Widget? onDoneWidget,
    Widget? onCancelWidget,
    super.key,
  })  : assert(steps.isNotEmpty, 'Steps must be superior to zero'),
        onDoneWidget = onDoneWidget ??
            Text(
              onDoneTitle ?? 'DONE',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
        onCancelWidget = onCancelWidget ??
            Text(
              onCancelTitle ?? 'CANCEL',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            );

  @override
  State<SimpleStepper> createState() => SimpleStepperState();
}

class SimpleStepperState extends State<SimpleStepper> {
  late PageController _pageController;
  late bool _canProceed;
  late bool _canGoBack;
  late double _currentStep;
  bool _isBusy = false;
  bool _isScrolling = false;

  PageController get controller => _pageController;

  /// Current step displayed in screen.
  int get currentStep => _currentStep.toInt();

  /// Whether the user can proceed to the next step.
  bool get canProceed => _canProceed;

  set canProceed(bool value) => setState(() => _canProceed = value);

  /// Whether the user can go back tp the previous step.
  bool get canGoBack => _canGoBack;

  set canGoBack(bool value) => setState(() => _canGoBack = value);

  bool get isLastStep => _currentStep.round() == (widget.steps.length - 1);

  bool get isFirstStep => _currentStep == 0.0;

  @override
  void initState() {
    super.initState();

    _canProceed = widget.canProceed;
    _canGoBack = widget.canGoBack;
    _currentStep = widget.initialStep.toDouble();

    _pageController = PageController(initialPage: widget.initialStep);
  }

  Future<void> next() async {
    if (_currentStep.round() == (widget.steps.length - 1)) return;

    setState(() => _isScrolling = true);

    if (widget.onNext != null) {
      final result = await widget.onNext!();

      if (!result) {
        return setState(() => _isScrolling = false);
      }
    }

    _animateScroll(_currentStep.round() + 1);
  }

  Future<void> prev() async {
    if (isFirstStep) {
      widget.onCancel();
    } else {
      setState(() => _isScrolling = true);

      if (widget.onPrev != null) {
        final result = await widget.onPrev!();

        if (!result) {
          return setState(() => _isScrolling = false);
        }
      }

      _animateScroll(_currentStep.round() - 1);
    }
  }

  Future<void> onDone() async {
    setState(() => _isBusy = true);

    final result = await widget.onDone();

    if (!result) {
      setState(() => _isBusy = false);
    }
  }

  Future<void> _animateScroll(int step) async {
    await _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );

    if (mounted) {
      setState(() {
        _currentStep = step.toDouble();
        _isScrolling = false;
      });
    }
  }

  bool _onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;

    if (widget.unfocusOnScroll && metrics.axis == Axis.horizontal) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    if (metrics is PageMetrics) {
      setState(() => _currentStep = metrics.page!);
    }

    return false;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: widget.scaffoldKey,
        backgroundColor: CupertinoColors.systemBackground,
        body: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: PageView(
                controller: _pageController,
                physics: widget.scrollable
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                children: widget.steps.map((step) => SimpleStep(step)).toList(),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 14,
              right: 14,
              child: SafeArea(
                maintainBottomViewPadding:
                    MediaQuery.of(context).viewInsets.bottom > 100,
                top: false,
                child: Row(
                  children: [
                    SimpleStepperButton(
                      widget.displayLeftButton
                          ? isFirstStep
                              ? widget.onCancelWidget
                              : canGoBack
                                  ? widget.displayPrevArrow
                                      ? Icon(
                                          Platform.isIOS
                                              ? CupertinoIcons.back
                                              : Icons.arrow_back,
                                        )
                                      : null
                                  : null
                          : null,
                      opacity: _isBusy ? 0.0 : 1.0,
                      onPressed: !_isScrolling && !_isBusy ? prev : null,
                    ),
                    DotsIndicatorWrapper(
                      count: widget.steps.length,
                      currentPosition: _currentStep,
                    ),
                    SimpleStepperButton(
                      widget.displayRightButton
                          ? canProceed
                              ? isLastStep
                                  ? widget.onDoneWidget
                                  : widget.displayNextArrow
                                      ? Icon(
                                          Platform.isIOS
                                              ? CupertinoIcons.forward
                                              : Icons.arrow_forward,
                                        )
                                      : null
                              : null
                          : null,
                      opacity: !_isBusy ? 1.0 : 0.0,
                      onPressed: !_isScrolling && !_isBusy
                          ? isLastStep
                              ? onDone
                              : next
                          : null,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
