import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../simple_stepper.dart';

class SimpleStepper extends StatefulWidget {
  final Key? scaffoldKey;
  final List<StepModel> steps;
  final int initialStep;

  /// Defines if the screens are scrollable by the horizontal swipe gesture.
  ///
  /// Defaults to `true`.
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

  /// Defines if the left button should be displayed.
  ///
  /// If value is `false`, it won't display the `onCancel` button or
  /// the `prev` arrow button.
  ///
  /// Defaults to `true`.
  final bool displayLeftButton;

  /// Defines if the right button should be displayed.
  ///
  /// If value is `false`, it won't display the `onDone` button or
  /// the `next` arrow button.
  ///
  /// Defaults to `true`.
  final bool displayRightButton;

  /// Defines if the left button should be displayed.
  ///
  /// If value is `false`, it won't display the `next` arrow button.
  ///
  /// Defaults to `true`.
  final bool displayNextArrow;

  /// Defines if the left button should be displayed.
  ///
  /// If value is `false`, it won't display the `prev` arrow button.
  ///
  /// Defaults to `true`.
  final bool displayPrevArrow;

  /// Defines if the dots indicator should be displayed.
  ///
  /// Defaults to `true`.
  final bool displayDotsIndicator;

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
    this.displayDotsIndicator = true,
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
  late bool _displayLeftButton;
  late bool _displayRightButton;
  late bool _displayNextArrow;
  late bool _displayPrevArrow;
  late bool _displayDotsIndicator;
  bool _isBusy = false;
  bool _isScrolling = false;

  PageController get controller => _pageController;

  /// Current step displayed on screen.
  int get currentStep => _currentStep.toInt();

  /// Whether the dots indicator is displayed on screen.
  bool get displayDotsIndicator => _displayDotsIndicator;

  set displayDotsIndicator(bool value) =>
      setState(() => _displayDotsIndicator = value);

  /// Whether the left button is displayed on screen.
  bool get displayLeftButton => _displayLeftButton;

  set displayLeftButton(bool value) =>
      setState(() => _displayLeftButton = value);

  /// Whether the right button is displayed on screen.
  bool get displayRightButton => _displayRightButton;

  set displayRightButton(bool value) =>
      setState(() => _displayRightButton = value);

  /// Whether the previous arrow button is displayed on screen.
  bool get displayPrevArrow => _displayPrevArrow;

  set displayPrevArrow(bool value) => setState(() => _displayPrevArrow = value);

  /// Whether the next arrow button is displayed on screen.
  bool get displayNextArrow => _displayNextArrow;

  set displayNextArrow(bool value) => setState(() => _displayNextArrow = value);

  /// Whether the user can proceed to the next step.
  bool get canProceed => _canProceed;

  set canProceed(bool value) => setState(() => _canProceed = value);

  /// Whether the user can go back to the previous step.
  bool get canGoBack => _canGoBack;

  set canGoBack(bool value) => setState(() => _canGoBack = value);

  /// Whether the user is currently in the last screen.
  bool get isLastStep => _currentStep.round() == (widget.steps.length - 1);

  /// Whether the user is currently in the first screen.
  bool get isFirstStep => _currentStep == 0.0;

  @override
  void initState() {
    super.initState();

    _canProceed = widget.canProceed;
    _canGoBack = widget.canGoBack;
    _displayLeftButton = widget.displayLeftButton;
    _displayRightButton = widget.displayRightButton;
    _displayNextArrow = widget.displayNextArrow;
    _displayPrevArrow = widget.displayPrevArrow;
    _displayDotsIndicator = widget.displayDotsIndicator;
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
                      _displayLeftButton
                          ? isFirstStep
                              ? widget.onCancelWidget
                              : canGoBack
                                  ? _displayPrevArrow
                                      ? const Icon(CupertinoIcons.back)
                                      : null
                                  : null
                          : null,
                      opacity: _isBusy ? 0.0 : 1.0,
                      onPressed: !_isScrolling && !_isBusy ? prev : null,
                    ),
                    if (_displayDotsIndicator)
                      DotsIndicatorWrapper(
                        count: widget.steps.length,
                        currentPosition: _currentStep,
                      )
                    else
                      const Spacer(),
                    SimpleStepperButton(
                      _displayRightButton
                          ? canProceed
                              ? isLastStep
                                  ? widget.onDoneWidget
                                  : _displayNextArrow
                                      ? const Icon(CupertinoIcons.forward)
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
