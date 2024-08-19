import 'package:flutter/widgets.dart';

class StepModel {
  final String? title;
  final Widget? titleWidget;
  final String? body;
  final Widget? bodyWidget;
  final Widget? image;
  final MainAxisAlignment alignment;

  const StepModel({
    this.title,
    this.titleWidget,
    this.body,
    this.bodyWidget,
    this.image,
    this.alignment = MainAxisAlignment.start,
  })  : assert(
          title != null || titleWidget != null,
          "You must provide either title (String) or titleWidget (Widget).",
        ),
        assert(
          (title == null) != (titleWidget == null),
          "You can not provide both title and titleWidget.",
        ),
        assert(
          body != null || bodyWidget != null,
          "You must provide either body (String) or bodyWidget (Widget).",
        ),
        assert(
          (body == null) != (bodyWidget == null),
          "You can not provide both body and bodyWidget.",
        );
}
