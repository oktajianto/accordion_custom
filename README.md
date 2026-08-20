# accordion_custom

[![flutter](https://img.shields.io/badge/flutter-website-deepskyblue.svg)](https://flutter.dev)
[![dart](https://img.shields.io/badge/dart-website-00B4AB.svg)](https://dart.dev)
[![platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Mac%20%7C%20Linux%20%7C%20Windows-brightgreen.svg)](https://flutter.dev)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A customizable, **zero-dependency** accordion (expandable panel list) for
Flutter. Simple to set up, yet scales to real needs: **single or multiple**
open panels, a programmatic controller, **nested** accordions, keyboard
navigation, and full styling — colors, borders, corner radius, padding, and the
icon.

**Works on every Flutter platform:** Android · iOS · Web · Windows · macOS ·
Linux. It is a pure-Dart package (no native code, no platform channels, no
third-party dependencies), so it runs anywhere Flutter runs.

## Why another accordion?

Flutter's built-in `ExpansionPanelList`/`ExpansionTile` is rigid: limited
styling, no single-vs-multiple switch, and awkward programmatic control.
`accordion_custom` gives you full control with zero dependencies:

- **Single or multiple** — open one panel at a time (classic accordion) or let
  panels open independently, via `AccordionMode`.
- **Slot-based, any widget** — each panel's header and content are ordinary
  widgets, so a panel can hold anything, including another accordion (nesting).
- **`.builder` for lists** — build panels lazily from a data list, like
  `ListView.builder`.
- **Programmatic control** — an `AccordionController` (a `ChangeNotifier`) with
  `expand`, `collapse`, `toggle`, `expandAll`, `collapseAll`, and read-back of
  which panels are open.
- **Full styling** — background (collapsed and expanded), border color/width,
  corner radius, padding, text style, and a rotating icon with configurable
  side, through `AccordionHeaderStyle` and `AccordionContentStyle`.
- **Keyboard & accessible** — ↑/↓ move focus between headers, Enter/Space
  toggle, and each header carries `Semantics` (button + expanded state).
- **Simple by default** — the basic case is a list of `AccordionItem`s; every
  extra feature is opt-in.

## Getting started

Add the package:

```bash
flutter pub add accordion_custom
```

Import it:

```dart
import 'package:accordion_custom/accordion_custom.dart';
```

## Basic usage

By default the accordion is in **single** mode: opening one panel closes the
others.

```dart
AccordionCustom(
  children: const [
    AccordionItem(
      header: Text('Section 1'),
      content: Text('Body of the first section.'),
    ),
    AccordionItem(
      header: Text('Section 2'),
      content: Text('Body of the second section.'),
    ),
  ],
)
```

## Multiple open panels

```dart
AccordionCustom(
  mode: AccordionMode.multiple,
  children: const [
    AccordionItem(
      header: Text('Panel one'),
      content: Text('Stays open independently.'),
      initiallyExpanded: true,
    ),
    AccordionItem(
      header: Text('Panel two'),
      content: Text('Also independent.'),
    ),
  ],
)
```

## Building from a data list

```dart
AccordionCustom.builder(
  itemCount: faqs.length,
  itemBuilder: (context, index) => AccordionItem(
    header: Text(faqs[index].question),
    content: Text(faqs[index].answer),
  ),
)
```

## Programmatic control

```dart
final controller = AccordionController();

AccordionCustom(
  mode: AccordionMode.multiple,
  controller: controller,
  children: const [
    AccordionItem(header: Text('A'), content: Text('...')),
    AccordionItem(header: Text('B'), content: Text('...')),
  ],
);

// Elsewhere:
controller.expandAll();
controller.collapse(0);
controller.toggle(1);
print(controller.expandedIndexes); // e.g. {1}
controller.addListener(() => print(controller.expandedIndexes));
```

Panels are addressed by their zero-based index. Dispose the controller when you
are done, like any `ChangeNotifier`.

## Styling

`AccordionHeaderStyle` controls the header **and the panel outline** (border and
radius); `AccordionContentStyle` controls the content area.

```dart
AccordionCustom(
  itemSpacing: 12,
  headerStyle: AccordionHeaderStyle(
    backgroundColor: Colors.indigo.shade50,
    expandedBackgroundColor: Colors.indigo.shade100,
    borderColor: Colors.indigo,
    borderWidth: 1.5,
    borderRadius: BorderRadius.circular(16),
    iconColor: Colors.indigo,
    iconPosition: AccordionIconPosition.leading,
    textStyle: const TextStyle(fontWeight: FontWeight.bold),
  ),
  contentStyle: AccordionContentStyle(
    backgroundColor: Colors.indigo.shade50,
    dividerColor: Colors.indigo.shade100,
  ),
  children: const [
    AccordionItem(header: Text('Themed'), content: Text('Fully styled.')),
  ],
)
```

Provide a completely custom header with `headerBuilder`, which receives the
current expanded state:

```dart
AccordionItem(
  headerBuilder: (context, isExpanded) => Row(
    children: [
      Icon(isExpanded ? Icons.folder_open : Icons.folder),
      const SizedBox(width: 8),
      const Text('Custom header'),
    ],
  ),
  content: const Text('...'),
)
```

## Nesting

A panel's `content` is any widget, so an accordion can contain another:

```dart
AccordionCustom(
  children: [
    AccordionItem(
      header: const Text('Outer'),
      content: AccordionCustom(
        children: const [
          AccordionItem(header: Text('Inner'), content: Text('Nested body.')),
        ],
      ),
    ),
  ],
)
```

## API overview

| Property | Description |
| --- | --- |
| `children` / `.builder(itemCount, itemBuilder)` | The panels, given directly or built lazily. |
| `mode` | `AccordionMode.single` (default) or `AccordionMode.multiple`. |
| `controller` | Optional `AccordionController` for programmatic control. |
| `headerStyle` | Header + panel outline styling (`AccordionHeaderStyle`). |
| `contentStyle` | Content area styling (`AccordionContentStyle`). |
| `animationDuration` / `animationCurve` | Expand/collapse animation. |
| `itemSpacing` | Vertical gap between panels. |
| `enableKeyboardNavigation` | ↑/↓ focus movement between headers. |

**`AccordionItem`**: `header` or `headerBuilder`, `content`,
`initiallyExpanded`, `enabled`, `semanticLabel`.

**`AccordionController`**: `expand`, `collapse`, `toggle`, `expandAll`,
`collapseAll`, `isExpanded(index)`, `expandedIndexes`.

## License

MIT — see [LICENSE](LICENSE).
