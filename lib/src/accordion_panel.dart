part of 'custom_accordion.dart';

/// A single accordion panel: a tappable header plus an animated content area.
///
/// Internal to [AccordionCustom]; not exported. The panel owns no expand state
/// of its own — [isExpanded] is passed in and [onToggle] is called on tap.
class _AccordionPanel extends StatelessWidget {
  const _AccordionPanel({
    required this.item,
    required this.isExpanded,
    required this.onToggle,
    required this.headerStyle,
    required this.contentStyle,
    required this.animationDuration,
    required this.animationCurve,
  });

  final AccordionItem item;
  final bool isExpanded;
  final VoidCallback onToggle;
  final AccordionHeaderStyle headerStyle;
  final AccordionContentStyle contentStyle;
  final Duration animationDuration;
  final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    final bool enabled = item.enabled;

    // A null borderColor falls back to the theme divider color; set borderWidth
    // to 0 for a borderless panel.
    final Color borderColor =
        headerStyle.borderColor ?? Theme.of(context).dividerColor;

    final Widget panel = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: headerStyle.borderRadius,
        border:
            headerStyle.borderWidth > 0
                ? Border.all(color: borderColor, width: headerStyle.borderWidth)
                : null,
      ),
      child: ClipRRect(
        borderRadius: headerStyle.borderRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildHeader(context, enabled), _buildContent()],
        ),
      ),
    );

    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      expanded: isExpanded,
      label: item.semanticLabel,
      child: panel,
    );
  }

  Widget _buildHeader(BuildContext context, bool enabled) {
    final Color? background =
        isExpanded
            ? (headerStyle.expandedBackgroundColor ??
                headerStyle.backgroundColor)
            : headerStyle.backgroundColor;

    final Widget headerContent =
        item.headerBuilder != null
            ? item.headerBuilder!(context, isExpanded)
            : DefaultTextStyle.merge(
              style:
                  headerStyle.textStyle ??
                  const TextStyle(fontWeight: FontWeight.w600),
              child: item.header!,
            );

    final List<Widget> row = [Expanded(child: headerContent)];
    final Widget? icon = _buildIcon();
    if (icon != null) {
      if (headerStyle.iconPosition == AccordionIconPosition.leading) {
        row.insert(0, icon);
        row.insert(1, SizedBox(width: headerStyle.iconGap));
      } else {
        row.add(SizedBox(width: headerStyle.iconGap));
        row.add(icon);
      }
    }

    Widget header = Padding(
      padding: headerStyle.padding,
      child: Row(children: row),
    );

    if (!enabled) {
      header = Opacity(opacity: 0.5, child: header);
    }

    return Material(
      type: MaterialType.transparency,
      child: Ink(
        color: background,
        child: InkWell(onTap: enabled ? onToggle : null, child: header),
      ),
    );
  }

  Widget? _buildIcon() {
    if (!headerStyle.showIcon) return null;
    final Widget base =
        headerStyle.icon ?? const Icon(Icons.keyboard_arrow_right);
    return AnimatedRotation(
      turns: isExpanded ? headerStyle.expandedIconTurns : 0,
      duration: animationDuration,
      curve: animationCurve,
      child:
          headerStyle.iconColor != null
              ? IconTheme.merge(
                data: IconThemeData(color: headerStyle.iconColor),
                child: base,
              )
              : base,
    );
  }

  Widget _buildContent() {
    // Collapse to zero height with a shrink child so AnimatedSize can tween
    // between the two. The real content is only built while expanded.
    final Widget child =
        isExpanded
            ? DecoratedBox(
              decoration: BoxDecoration(
                color: contentStyle.backgroundColor,
                border:
                    contentStyle.dividerColor != null
                        ? Border(
                          top: BorderSide(
                            color: contentStyle.dividerColor!,
                            width: contentStyle.dividerWidth,
                          ),
                        )
                        : null,
              ),
              child: Padding(
                padding: contentStyle.padding,
                child: DefaultTextStyle.merge(
                  style: contentStyle.textStyle ?? const TextStyle(),
                  child: item.content,
                ),
              ),
            )
            : const SizedBox(width: double.infinity);

    return ClipRect(
      child: AnimatedSize(
        duration: animationDuration,
        curve: animationCurve,
        alignment: Alignment.topCenter,
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
