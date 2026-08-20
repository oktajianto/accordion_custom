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

### Per-panel styling

`headerStyle`/`contentStyle` on `AccordionCustom` apply to every panel. To style
one panel differently, set `headerStyle`/`contentStyle` on its `AccordionItem` —
they **replace** the accordion-level style for that panel:

```dart
AccordionCustom(
  children: [
    AccordionItem(
      header: const Text('Success'),
      headerStyle: AccordionHeaderStyle(backgroundColor: Colors.green.shade50),
      contentStyle: AccordionContentStyle(backgroundColor: Colors.green.shade50),
      content: const Text('Green header and body.'),
    ),
    AccordionItem(
      header: const Text('Warning'),
      headerStyle: AccordionHeaderStyle(backgroundColor: Colors.orange.shade50),
      contentStyle: AccordionContentStyle(backgroundColor: Colors.orange.shade50),
      content: const Text('Orange header and body.'),
    ),
  ],
)
```

To inherit the accordion's style and change only a few fields, pass a
`copyWith`: `contentStyle: myBaseContentStyle.copyWith(backgroundColor: ...)`.

### Divider between header and content

By default there is **no line** separating the header from the content. To show
one, set `dividerColor` (and optionally `dividerWidth`) on the content style:

```dart
AccordionCustom(
  contentStyle: AccordionContentStyle(
    dividerColor: Colors.grey.shade300,
    dividerWidth: 1, // optional, defaults to 1
  ),
  children: const [
    AccordionItem(
      header: Text('What is accordion_custom?'),
      content: Text('A line now separates this content from the header.'),
    ),
  ],
)
```

The divider only shows while the panel is expanded.

### Custom padding

The header and the content have independent padding
(`EdgeInsetsGeometry`, so `only`/`symmetric`/`EdgeInsetsDirectional` all work):

```dart
AccordionCustom(
  headerStyle: const AccordionHeaderStyle(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
  ),
  contentStyle: const AccordionContentStyle(
    padding: EdgeInsets.all(24),
  ),
  children: const [
    AccordionItem(header: Text('Roomy panel'), content: Text('More breathing room.')),
  ],
)
```

Defaults: header `EdgeInsets.symmetric(horizontal: 16, vertical: 14)`, content
`EdgeInsets.fromLTRB(16, 4, 16, 16)`.

### Custom header

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

### Custom or hidden icon

Swap the default chevron for any widget, change its rotation, or hide it:

```dart
AccordionCustom(
  headerStyle: const AccordionHeaderStyle(
    icon: Icon(Icons.add),        // any widget
    expandedIconTurns: 0.125,     // 45° turn when expanded (a + becomes ×)
    iconPosition: AccordionIconPosition.leading,
  ),
  children: const [
    AccordionItem(header: Text('Custom icon'), content: Text('...')),
  ],
)

// Or hide the icon entirely:
AccordionCustom(
  headerStyle: const AccordionHeaderStyle(showIcon: false),
  children: const [
    AccordionItem(header: Text('No icon'), content: Text('...')),
  ],
)
```

### Disabled panels

A panel with `enabled: false` is dimmed and ignores taps (a controller can still
change it):

```dart
AccordionCustom(
  children: const [
    AccordionItem(
      header: Text('Unavailable'),
      content: Text('You cannot open this by tapping.'),
      enabled: false,
    ),
  ],
)
```

### Initial state

Mark a panel `initiallyExpanded: true` to have it open on first build. In single
mode, if several set it, only the first wins:

```dart
AccordionCustom(
  mode: AccordionMode.multiple,
  children: const [
    AccordionItem(
      header: Text('Open on start'),
      content: Text('Visible without a tap.'),
      initiallyExpanded: true,
    ),
    AccordionItem(header: Text('Closed'), content: Text('...')),
  ],
)
```

### Animation

Tune the expand/collapse (and icon rotation) animation:

```dart
AccordionCustom(
  animationDuration: const Duration(milliseconds: 500),
  animationCurve: Curves.easeInOutBack,
  children: const [
    AccordionItem(header: Text('Slow & bouncy'), content: Text('...')),
  ],
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
`initiallyExpanded`, `enabled`, `semanticLabel`, and optional per-panel
`headerStyle` / `contentStyle`.

**`AccordionController`**: `expand`, `collapse`, `toggle`, `expandAll`,
`collapseAll`, `isExpanded(index)`, `expandedIndexes`.

## License

MIT — see [LICENSE](LICENSE).
