## 0.1.0

- Initial release.
- `AccordionCustom` with a slot-based `children:` API and a lazy
  `AccordionCustom.builder` constructor.
- Single- and multiple-open modes via `AccordionMode`.
- `AccordionController` (a `ChangeNotifier`) with `expand`, `collapse`,
  `toggle`, `expandAll`, `collapseAll`, `isExpanded`, and `expandedIndexes`.
- Per-item `initiallyExpanded`, `enabled`, custom `header`/`headerBuilder`, and
  arbitrary `content` (including nested accordions).
- Full styling through `AccordionHeaderStyle` (background, border color/width,
  corner radius, padding, text style, and a rotating icon with configurable
  position) and `AccordionContentStyle` (background, padding, text style,
  optional divider).
- Keyboard navigation (↑/↓ between headers, Enter/Space to toggle) and
  `Semantics` for accessibility.
- Zero dependencies; pure Dart, works on every Flutter platform.
