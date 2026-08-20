import 'package:flutter/material.dart';

/// Where the expand/collapse icon sits relative to the header content.
enum AccordionIconPosition {
  /// Before the header content (left in LTR).
  leading,

  /// After the header content (right in LTR).
  trailing,
}

/// Styling for an accordion panel's header (the tappable trigger row).
///
/// Every field is optional; `null` values fall back to sensible defaults
/// derived from the ambient [Theme]. The border color, width, and radius here
/// frame the whole panel (header + content), so a single style controls the
/// panel's outline and corner rounding.
@immutable
class AccordionHeaderStyle {
  /// Creates a header style. All parameters are optional.
  const AccordionHeaderStyle({
    this.backgroundColor,
    this.expandedBackgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.textStyle,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.icon,
    this.iconColor,
    this.showIcon = true,
    this.iconPosition = AccordionIconPosition.trailing,
    this.expandedIconTurns = 0.25,
    this.iconGap = 8,
  });

  /// Fill color of the header while collapsed. Defaults to transparent.
  final Color? backgroundColor;

  /// Fill color of the header while expanded. Falls back to [backgroundColor]
  /// when `null`.
  final Color? expandedBackgroundColor;

  /// Inner padding of the header row.
  final EdgeInsetsGeometry padding;

  /// Text style applied to plain [Text] in the header. Defaults to the theme
  /// body text at [FontWeight.w600].
  final TextStyle? textStyle;

  /// Outline color of the whole panel. When `null`, defaults to the theme
  /// divider color. Set [borderWidth] to `0` for a borderless panel.
  final Color? borderColor;

  /// Outline width in logical pixels. `0` removes the border entirely.
  final double borderWidth;

  /// Corner radius of the panel (also clips the content).
  final BorderRadius borderRadius;

  /// Custom expand/collapse icon. Defaults to a right-pointing chevron that
  /// rotates by [expandedIconTurns] when the panel opens.
  final Widget? icon;

  /// Color of the default icon. Defaults to the theme icon color. Ignored when
  /// a custom [icon] is supplied with its own color.
  final Color? iconColor;

  /// Whether to show the expand/collapse icon at all.
  final bool showIcon;

  /// Which side of the header the icon sits on.
  final AccordionIconPosition iconPosition;

  /// Rotation (in turns) applied to the icon when the panel is expanded. The
  /// default `0.25` turns a right chevron into a down chevron.
  final double expandedIconTurns;

  /// Gap between the header content and the icon, in logical pixels.
  final double iconGap;

  /// Returns a copy with the given fields replaced.
  AccordionHeaderStyle copyWith({
    Color? backgroundColor,
    Color? expandedBackgroundColor,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    Widget? icon,
    Color? iconColor,
    bool? showIcon,
    AccordionIconPosition? iconPosition,
    double? expandedIconTurns,
    double? iconGap,
  }) {
    return AccordionHeaderStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      expandedBackgroundColor:
          expandedBackgroundColor ?? this.expandedBackgroundColor,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      showIcon: showIcon ?? this.showIcon,
      iconPosition: iconPosition ?? this.iconPosition,
      expandedIconTurns: expandedIconTurns ?? this.expandedIconTurns,
      iconGap: iconGap ?? this.iconGap,
    );
  }
}
