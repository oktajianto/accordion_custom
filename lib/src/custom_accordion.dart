import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'accordion_content_style.dart';
import 'accordion_header_style.dart';

part 'accordion_controller.dart';
part 'accordion_panel.dart';

/// How many panels may be open at once.
enum AccordionMode {
  /// Opening a panel closes any other open panel (classic accordion).
  single,

  /// Panels open and close independently; any number may be open at once.
  multiple,
}

/// Signature for building a fully custom header for an [AccordionItem].
///
/// [isExpanded] reflects the panel's current state, so the header can react to
/// it (e.g. change color or swap a label). The expand/collapse icon is still
/// added by the accordion unless disabled via the header style.
typedef AccordionHeaderBuilder =
    Widget Function(BuildContext context, bool isExpanded);

/// Signature for lazily building the item at [index] for
/// [AccordionCustom.builder].
typedef AccordionItemBuilder =
    AccordionItem Function(BuildContext context, int index);

/// One panel in an [AccordionCustom]: a header and the content it reveals.
///
/// Provide either a plain [header] widget or a [headerBuilder] for a header
/// that reacts to the expanded state — exactly one is required. [content] is
/// any widget (including another [AccordionCustom] for nesting).
@immutable
class AccordionItem {
  /// Creates a panel. Supply one of [header] or [headerBuilder].
  const AccordionItem({
    this.header,
    this.headerBuilder,
    required this.content,
    this.initiallyExpanded = false,
    this.enabled = true,
    this.semanticLabel,
  }) : assert(
         (header == null) != (headerBuilder == null),
         'Provide exactly one of header or headerBuilder.',
       );

  /// The header widget. Plain [Text] inherits the header style's text style.
  /// Mutually exclusive with [headerBuilder].
  final Widget? header;

  /// Builds a header that reacts to the expanded state. Mutually exclusive with
  /// [header].
  final AccordionHeaderBuilder? headerBuilder;

  /// The content revealed when the panel is expanded. May be any widget,
  /// including a nested [AccordionCustom].
  final Widget content;

  /// Whether this panel starts expanded on first build. In
  /// [AccordionMode.single], if several items set this, only the first wins.
  final bool initiallyExpanded;

  /// Whether the panel can be toggled. A disabled panel is dimmed and ignores
  /// taps; a controller can still change it.
  final bool enabled;

  /// Optional semantic label announced for the header by screen readers.
  final String? semanticLabel;
}

/// A customizable, zero-dependency accordion (expandable panel list).
///
/// The simplest usage lists panels as [AccordionItem]s:
///
/// ```dart
/// AccordionCustom(
///   children: [
///     AccordionItem(header: Text('Section 1'), content: Text('Body 1')),
///     AccordionItem(header: Text('Section 2'), content: Text('Body 2')),
///   ],
/// )
/// ```
///
/// Use [AccordionCustom.builder] to build panels lazily from a data list. The
/// [mode] chooses single- vs multiple-open behavior, an [AccordionController]
/// drives it programmatically, and the header/content styles cover colors,
/// borders, radius, padding, and the icon.
class AccordionCustom extends StatefulWidget {
  /// Creates an accordion from an explicit list of [children].
  const AccordionCustom({
    super.key,
    required List<AccordionItem> this.children,
    this.mode = AccordionMode.single,
    this.controller,
    this.headerStyle = const AccordionHeaderStyle(),
    this.contentStyle = const AccordionContentStyle(),
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOut,
    this.itemSpacing = 8,
    this.enableKeyboardNavigation = true,
  }) : itemCount = null,
       itemBuilder = null;

  /// Creates an accordion that builds its [itemCount] panels lazily via
  /// [itemBuilder], like `ListView.builder`.
  const AccordionCustom.builder({
    super.key,
    required int this.itemCount,
    required AccordionItemBuilder this.itemBuilder,
    this.mode = AccordionMode.single,
    this.controller,
    this.headerStyle = const AccordionHeaderStyle(),
    this.contentStyle = const AccordionContentStyle(),
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOut,
    this.itemSpacing = 8,
    this.enableKeyboardNavigation = true,
  }) : children = null,
       assert(itemCount >= 0, 'itemCount cannot be negative.');

  /// The panels, when built with the default constructor. `null` for
  /// [AccordionCustom.builder].
  final List<AccordionItem>? children;

  /// The number of panels, when built with [AccordionCustom.builder].
  final int? itemCount;

  /// Builds the panel at a given index, for [AccordionCustom.builder].
  final AccordionItemBuilder? itemBuilder;

  /// Whether one or many panels may be open at once.
  final AccordionMode mode;

  /// Optional external controller. When omitted, the accordion manages its own
  /// state internally.
  final AccordionController? controller;

  /// Styling for every panel header and the panel outline.
  final AccordionHeaderStyle headerStyle;

  /// Styling for every panel's content area.
  final AccordionContentStyle contentStyle;

  /// Duration of the expand/collapse (and icon rotation) animation.
  final Duration animationDuration;

  /// Curve of the expand/collapse animation.
  final Curve animationCurve;

  /// Vertical gap between panels, in logical pixels.
  final double itemSpacing;

  /// Whether ↑/↓ move focus between headers (Enter/Space toggle the focused
  /// header regardless).
  final bool enableKeyboardNavigation;

  @override
  State<AccordionCustom> createState() => _AccordionCustomState();
}

class _AccordionCustomState extends State<AccordionCustom> {
  late AccordionController _controller;
  bool _ownsController = false;
  bool _appliedInitial = false;

  int get _count => widget.children?.length ?? widget.itemCount ?? 0;

  AccordionItem _itemAt(BuildContext context, int index) =>
      widget.children?[index] ?? widget.itemBuilder!(context, index);

  @override
  void initState() {
    super.initState();
    _attachController(widget.controller);
  }

  @override
  void didUpdateWidget(AccordionCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _detachController();
      _attachController(widget.controller);
      _appliedInitial = true; // don't re-apply initial to a swapped controller
    }
  }

  void _attachController(AccordionController? external) {
    _controller = external ?? AccordionController();
    _ownsController = external == null;
    _controller.addListener(_onControllerChanged);
  }

  void _detachController() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _detachController();
    super.dispose();
  }

  Set<int> _initialExpanded(BuildContext context) {
    final Set<int> result = <int>{};
    for (var i = 0; i < _count; i++) {
      if (_itemAt(context, i).initiallyExpanded) result.add(i);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // Keep the controller in step with the current item count and mode before
    // reading expanded state, then apply the items' initial state once.
    _controller._sync(itemCount: _count, mode: widget.mode);
    if (!_appliedInitial) {
      _controller._applyInitial(_initialExpanded(context));
      _appliedInitial = true;
    }

    final List<Widget> panels = [];
    for (var i = 0; i < _count; i++) {
      if (i > 0 && widget.itemSpacing > 0) {
        panels.add(SizedBox(height: widget.itemSpacing));
      }
      final int index = i;
      panels.add(
        _AccordionPanel(
          item: _itemAt(context, index),
          isExpanded: _controller.isExpanded(index),
          onToggle: () => _controller.toggle(index),
          headerStyle: widget.headerStyle,
          contentStyle: widget.contentStyle,
          animationDuration: widget.animationDuration,
          animationCurve: widget.animationCurve,
        ),
      );
    }

    Widget column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: panels,
    );

    if (widget.enableKeyboardNavigation) {
      column = FocusTraversalGroup(child: column);
      column = Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(
            TraversalDirection.down,
          ),
          SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(
            TraversalDirection.up,
          ),
        },
        child: column,
      );
    }

    return column;
  }
}
