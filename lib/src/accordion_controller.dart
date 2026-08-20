part of 'custom_accordion.dart';

/// Controls an [AccordionCustom] programmatically and reports which panels are
/// expanded.
///
/// Create one, pass it to an accordion's `controller`, and call [expand],
/// [collapse], [toggle], [expandAll], or [collapseAll] from anywhere (e.g.
/// another button). Because it is a [ChangeNotifier], you can also listen for
/// changes:
///
/// ```dart
/// final controller = AccordionController();
///
/// AccordionCustom(
///   controller: controller,
///   children: [AccordionItem(header: Text('A'), content: Text('...'))],
/// );
///
/// // Elsewhere:
/// ElevatedButton(onPressed: () => controller.toggle(0), child: const Text('Toggle'));
/// controller.addListener(() => print('open: ${controller.expandedIndexes}'));
/// ```
///
/// Panels are addressed by their zero-based [index] in the accordion's child
/// list. A controller drives a single accordion at a time. Dispose it when you
/// are done, like any [ChangeNotifier].
class AccordionController extends ChangeNotifier {
  /// Creates a controller. Attach it to an [AccordionCustom] via its
  /// `controller` argument.
  AccordionController();

  final Set<int> _expanded = <int>{};
  AccordionMode _mode = AccordionMode.single;
  int _itemCount = 0;

  /// The indexes of every currently expanded panel, as an unmodifiable set.
  Set<int> get expandedIndexes => Set<int>.unmodifiable(_expanded);

  /// Whether the panel at [index] is currently expanded.
  bool isExpanded(int index) => _expanded.contains(index);

  /// Expands the panel at [index].
  ///
  /// No-op if [index] is out of range or already expanded. In
  /// [AccordionMode.single] this first collapses any other open panel.
  void expand(int index) {
    if (index < 0 || index >= _itemCount || _expanded.contains(index)) return;
    if (_mode == AccordionMode.single) _expanded.clear();
    _expanded.add(index);
    notifyListeners();
  }

  /// Collapses the panel at [index]. No-op if it is already collapsed.
  void collapse(int index) {
    if (_expanded.remove(index)) notifyListeners();
  }

  /// Expands the panel at [index] if collapsed, or collapses it if expanded.
  void toggle(int index) => isExpanded(index) ? collapse(index) : expand(index);

  /// Expands every panel. Only meaningful in [AccordionMode.multiple]; a no-op
  /// in [AccordionMode.single].
  void expandAll() {
    if (_mode == AccordionMode.single || _itemCount == 0) return;
    final int before = _expanded.length;
    for (var i = 0; i < _itemCount; i++) {
      _expanded.add(i);
    }
    if (_expanded.length != before) notifyListeners();
  }

  /// Collapses every panel.
  void collapseAll() {
    if (_expanded.isEmpty) return;
    _expanded.clear();
    notifyListeners();
  }

  // --- Internal: wired up by AccordionCustom's state ---

  /// Keeps the controller in step with the widget's item count and mode. Prunes
  /// stale indexes and enforces the single-open invariant. Does not notify;
  /// called during build.
  void _sync({required int itemCount, required AccordionMode mode}) {
    _itemCount = itemCount;
    _mode = mode;
    _expanded.removeWhere((i) => i < 0 || i >= itemCount);
    if (mode == AccordionMode.single && _expanded.length > 1) {
      final int keep = _expanded.first;
      _expanded
        ..clear()
        ..add(keep);
    }
  }

  /// Applies the initial expanded set derived from the items. Does not notify.
  void _applyInitial(Set<int> initial) {
    _expanded
      ..clear()
      ..addAll(initial);
    if (_mode == AccordionMode.single && _expanded.length > 1) {
      final int keep = _expanded.first;
      _expanded
        ..clear()
        ..add(keep);
    }
  }
}
