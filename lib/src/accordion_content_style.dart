import 'package:flutter/material.dart';

/// Styling for an accordion panel's content area (revealed when expanded).
///
/// Every field is optional; `null` values fall back to sensible defaults. The
/// panel's outline and corner radius come from the header style, so this class
/// only covers the content's fill, padding, text, and an optional divider that
/// separates the content from the header.
@immutable
class AccordionContentStyle {
  /// Creates a content style. All parameters are optional.
  const AccordionContentStyle({
    this.backgroundColor,
    this.padding = const EdgeInsets.fromLTRB(16, 4, 16, 16),
    this.textStyle,
    this.dividerColor,
    this.dividerWidth = 1,
  });

  /// Fill color of the content area. Defaults to transparent.
  final Color? backgroundColor;

  /// Inner padding of the content area.
  final EdgeInsetsGeometry padding;

  /// Text style applied to plain [Text] in the content. Defaults to the theme
  /// body text.
  final TextStyle? textStyle;

  /// Color of a divider drawn between the header and the content. When `null`
  /// (the default) no divider is drawn.
  final Color? dividerColor;

  /// Thickness of the header/content divider, in logical pixels. Ignored when
  /// [dividerColor] is `null`.
  final double dividerWidth;

  /// Returns a copy with the given fields replaced.
  AccordionContentStyle copyWith({
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Color? dividerColor,
    double? dividerWidth,
  }) {
    return AccordionContentStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerWidth: dividerWidth ?? this.dividerWidth,
    );
  }
}
