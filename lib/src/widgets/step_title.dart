import 'package:flutter/material.dart';

/// The `StepTitle` widget offers a flexible layout to accommodate various design needs.
/// It allows customization of the title and subtitle text styles, alignment, and color,
/// along with an option to include a logo and a divider below the text.
///
/// {@tool snippet}
///
/// Example usage:
///
/// ```dart
/// StepTitle(
///   'Step 1',
///   subtitle: 'Personal Information',
///   titleColor: Colors.blue,
///   logo: Icon(Icons.person),
/// )
/// ```
/// {@end-tool}
///
/// This example creates a `StepTitle` with a title, a subtitle, a blue title color,
/// and an icon representing a person.
class StepTitle extends StatelessWidget {
  /// The main title text. This is a required parameter.
  final String title;

  /// The alignment of the title text.
  ///
  /// Defaults to `null`, which uses the default text alignment behavior.
  final TextAlign? titleAlign;

  /// The font size of the title text.
  ///
  /// Defaults to `20.0`.
  final double titleSize;

  /// The font weight of the title text.
  ///
  /// Defaults to `FontWeight.w500`.
  final FontWeight titleWeight;

  /// The height of the title text line.
  ///
  /// Defaults to `1.0`.
  final double titleHeight;

  /// The color of the title text.
  ///
  /// If `null`, the theme's text color is used.
  final Color? titleColor;

  /// The optional subtitle text.
  ///
  /// If `null`, no subtitle is displayed.
  final String? subtitle;

  /// The alignment of the subtitle text.
  ///
  /// Defaults to `null`, which uses the default text alignment behavior.
  final TextAlign? subtitleAlign;

  /// The font weight of the subtitle text.
  ///
  /// Defaults to `null`, which uses the default font weight.
  final FontWeight? subtitleWeight;

  /// The font size of the subtitle text.
  ///
  /// Defaults to `15.0`.
  final double subtitleSize;

  /// The height of the subtitle text line.
  ///
  /// Defaults to `null`, which uses the default font height.
  final double? subtitleHeight;

  /// The color of the subtitle text.
  ///
  /// Defaults to `Colors.black54`.
  final Color? subtitleColor;

  /// An optional widget to display next to the title, typically an icon or image.
  ///
  /// If `null`, no logo is displayed.
  final Widget? logo;

  /// Whether to include a divider below the text. Defaults to `true`.
  final bool includeDivider;

  /// The height of the divider. Only relevant if `includeDivider` is `true`.
  ///
  /// Defaults to `35.0`.
  final double dividerHeight;

  /// The amount of space to indent the divider from the left and right edges.
  /// Only relevant if `includeDivider` is `true`.
  ///
  /// Defaults to `20.0`.
  final double dividerIndent;

  const StepTitle(
    this.title, {
    this.titleAlign,
    this.titleSize = 20.0,
    this.titleWeight = FontWeight.w500,
    this.titleHeight = 1.0,
    this.titleColor,
    this.subtitle,
    this.subtitleAlign,
    this.subtitleWeight,
    this.subtitleHeight,
    this.subtitleSize = 15.0,
    this.subtitleColor = Colors.black54,
    this.logo,
    this.includeDivider = true,
    this.dividerHeight = 35,
    this.dividerIndent = 20,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Row(
            children: [
              if (logo != null)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 20,
                  ),
                  child: logo,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: titleWeight,
                          height: titleHeight,
                          color: titleColor,
                        ),
                        textAlign: titleAlign,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: subtitleSize,
                            fontWeight: subtitleWeight,
                            height: subtitleHeight,
                            color: subtitleColor,
                          ),
                          textAlign: subtitleAlign,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (includeDivider)
            Divider(
              height: dividerHeight,
              thickness: .5,
              indent: dividerIndent,
              endIndent: dividerIndent,
            ),
        ],
      ),
    );
  }
}
