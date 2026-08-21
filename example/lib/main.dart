// A runnable gallery for accordion_custom: each card below is a focused demo of
// one feature. For the full, copy-paste examples, see the README on pub.dev:
// https://pub.dev/packages/accordion_custom
import 'package:accordion_custom/accordion_custom.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'accordion_custom demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// A single source of truth for every feature demo, reused by the scrolling
// gallery on the home page and by the per-feature screenshot pages below.
const List<(String, Widget)> demos = [
  ('Single mode (default)', BasicSingleDemo()),
  ('Multiple mode', MultipleDemo()),
  ('.builder from a data list', BuilderDemo()),
  ('Controller: expand / collapse all', ControllerDemo()),
  ('Custom colors, border & radius', StyledDemo()),
  ('Per-panel styling (different per item)', PerPanelDemo()),
  ('Custom padding', PaddingDemo()),
  ('Divider between header & content', DividerDemo()),
  ('Custom header (headerBuilder)', CustomHeaderDemo()),
  ('Custom & hidden icon', IconDemo()),
  ('Disabled panel', DisabledDemo()),
  ('Initially expanded panel', InitialStateDemo()),
  ('Animation speed & curve', AnimationDemo()),
  ('Nested accordion', NestedDemo()),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('accordion_custom')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final (title, demo) in demos) _Section(title, demo),
          const Divider(),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text('Open per-feature demos (for screenshots)'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const DemoGalleryPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// A plain list of buttons — one per feature. Tapping a button opens that single
// demo on its own screen, so you can screenshot each feature in isolation.
class DemoGalleryPage extends StatelessWidget {
  const DemoGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Per-feature demos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final (title, demo) in demos)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder:
                            (_) => DemoDetailPage(title: title, demo: demo),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(title, textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// A single feature on its own screen, ready to screenshot.
class DemoDetailPage extends StatelessWidget {
  const DemoDetailPage({super.key, required this.title, required this.demo});

  final String title;
  final Widget demo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(padding: const EdgeInsets.all(16), children: [demo]),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.child);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// --- Demos ------------------------------------------------------------------

class BasicSingleDemo extends StatelessWidget {
  const BasicSingleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccordionCustom(
      children: [
        AccordionItem(
          header: Text('What is accordion_custom?'),
          content: Text(
            'A zero-dependency, fully customizable accordion for Flutter. '
            'Opening one panel closes the others in single mode.',
          ),
        ),
        AccordionItem(
          header: Text('Does it have dependencies?'),
          content: Text('No. Pure Dart, works on every Flutter platform.'),
        ),
        AccordionItem(
          header: Text('Can I style it?'),
          content: Text(
            'Yes — colors, borders, radius, padding, and the icon.',
          ),
        ),
      ],
    );
  }
}

class MultipleDemo extends StatelessWidget {
  const MultipleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccordionCustom(
      mode: AccordionMode.multiple,
      children: [
        AccordionItem(
          header: Text('Panel one'),
          content: Text('Open me and the others stay open too.'),
          initiallyExpanded: true,
        ),
        AccordionItem(
          header: Text('Panel two'),
          content: Text('Independent open/close per panel.'),
        ),
      ],
    );
  }
}

class ControllerDemo extends StatefulWidget {
  const ControllerDemo({super.key});

  @override
  State<ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<ControllerDemo> {
  final AccordionController _controller = AccordionController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            OutlinedButton(
              onPressed: _controller.expandAll,
              child: const Text('Expand all'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: _controller.collapseAll,
              child: const Text('Collapse all'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AccordionCustom(
          mode: AccordionMode.multiple,
          controller: _controller,
          children: const [
            AccordionItem(header: Text('Alpha'), content: Text('First body.')),
            AccordionItem(header: Text('Beta'), content: Text('Second body.')),
            AccordionItem(header: Text('Gamma'), content: Text('Third body.')),
          ],
        ),
      ],
    );
  }
}

class StyledDemo extends StatelessWidget {
  const StyledDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return AccordionCustom(
      itemSpacing: 12,
      headerStyle: AccordionHeaderStyle(
        backgroundColor: Colors.indigo.shade50,
        expandedBackgroundColor: Colors.indigo.shade100,
        borderColor: Colors.indigo,
        borderWidth: 1.5,
        borderRadius: BorderRadius.circular(16),
        iconColor: Colors.indigo,
        iconPosition: AccordionIconPosition.leading,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
      contentStyle: AccordionContentStyle(
        // A clearly visible custom body background.
        backgroundColor: Colors.indigo.shade50,
        dividerColor: Colors.indigo.shade100,
      ),
      children: const [
        // Both panels share the same style — they only differ in text. The
        // second one exists to show the itemSpacing gap between cards.
        AccordionItem(
          header: Text('Fully themed panel'),
          content: Text(
            'Header AND body backgrounds, border color and width, corner '
            'radius, the icon side, and text style all come from the styles.',
          ),
        ),
        AccordionItem(
          header: Text('Second themed panel'),
          content: Text('Same style as above; itemSpacing adds the gap.'),
        ),
      ],
    );
  }
}

class PerPanelDemo extends StatelessWidget {
  const PerPanelDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // headerStyle/contentStyle on an AccordionItem replace the accordion-level
    // style for that panel, so each panel can look different.
    return AccordionCustom(
      children: [
        AccordionItem(
          header: const Text('Success'),
          headerStyle: AccordionHeaderStyle(
            backgroundColor: Colors.green.shade50,
            borderColor: Colors.green.shade300,
            iconColor: Colors.green.shade700,
          ),
          contentStyle: AccordionContentStyle(
            backgroundColor: Colors.green.shade50,
          ),
          content: const Text('This panel has a green header and body.'),
        ),
        AccordionItem(
          header: const Text('Warning'),
          headerStyle: AccordionHeaderStyle(
            backgroundColor: Colors.orange.shade50,
            borderColor: Colors.orange.shade300,
            iconColor: Colors.orange.shade800,
          ),
          contentStyle: AccordionContentStyle(
            backgroundColor: Colors.orange.shade50,
          ),
          content: const Text('This one is orange — a different body color.'),
        ),
      ],
    );
  }
}

class PaddingDemo extends StatelessWidget {
  const PaddingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccordionCustom(
      headerStyle: AccordionHeaderStyle(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      contentStyle: AccordionContentStyle(padding: EdgeInsets.all(24)),
      children: [
        AccordionItem(
          header: Text('Roomy panel'),
          content: Text(
            'Header and content use independent padding. Here the header is '
            'taller and the content sits inside 24px on every side.',
          ),
          initiallyExpanded: true,
        ),
        AccordionItem(
          header: Text('Second panel'),
          content: Text('Same generous padding applies.'),
        ),
      ],
    );
  }
}

class DividerDemo extends StatelessWidget {
  const DividerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // The header/content divider is off by default; enable it via
    // AccordionContentStyle.dividerColor.
    return AccordionCustom(
      contentStyle: AccordionContentStyle(
        dividerColor: Colors.grey.shade300,
        dividerWidth: 1,
      ),
      children: const [
        AccordionItem(
          header: Text('What is accordion_custom?'),
          content: Text(
            'A line now separates this content from the header. '
            'The divider only shows while the panel is expanded.',
          ),
          initiallyExpanded: true,
        ),
        AccordionItem(
          header: Text('Another panel'),
          content: Text('Same divider style applies here too.'),
        ),
      ],
    );
  }
}

class CustomHeaderDemo extends StatelessWidget {
  const CustomHeaderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // headerBuilder receives the current expanded state, so the header can
    // react to it (icon swap, color change, etc.).
    return AccordionCustom(
      children: [
        AccordionItem(
          headerBuilder:
              (context, isExpanded) => Row(
                children: [
                  Icon(
                    isExpanded ? Icons.folder_open : Icons.folder,
                    color: Colors.amber.shade800,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isExpanded ? 'Folder (open)' : 'Folder',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
          content: const Text('The header rebuilt itself when you opened it.'),
        ),
      ],
    );
  }
}

class IconDemo extends StatelessWidget {
  const IconDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // A "+" that rotates 45° into an "x" when expanded.
        AccordionCustom(
          headerStyle: AccordionHeaderStyle(
            icon: Icon(Icons.add),
            expandedIconTurns: 0.125,
            iconPosition: AccordionIconPosition.leading,
          ),
          children: [
            AccordionItem(
              header: Text('Custom "+" icon'),
              content: Text('The plus rotates 45° into a cross when open.'),
            ),
          ],
        ),
        SizedBox(height: 12),
        // No icon at all.
        AccordionCustom(
          headerStyle: AccordionHeaderStyle(showIcon: false),
          children: [
            AccordionItem(
              header: Text('No icon'),
              content: Text('showIcon: false hides the indicator entirely.'),
            ),
          ],
        ),
      ],
    );
  }
}

class DisabledDemo extends StatelessWidget {
  const DisabledDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccordionCustom(
      children: [
        AccordionItem(
          header: Text('Available'),
          content: Text('This one opens on tap.'),
        ),
        AccordionItem(
          header: Text('Unavailable (disabled)'),
          content: Text('You should not be able to read this by tapping.'),
          enabled: false,
        ),
      ],
    );
  }
}

class InitialStateDemo extends StatelessWidget {
  const InitialStateDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // initiallyExpanded: true opens a panel on first build. In single mode only
    // the first one wins, so multiple mode is used here to keep it open.
    return const AccordionCustom(
      mode: AccordionMode.multiple,
      children: [
        AccordionItem(
          header: Text('Open on start'),
          content: Text('This panel is visible without a tap.'),
          initiallyExpanded: true,
        ),
        AccordionItem(
          header: Text('Closed on start'),
          content: Text('This one begins collapsed.'),
        ),
      ],
    );
  }
}

class AnimationDemo extends StatelessWidget {
  const AnimationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccordionCustom(
      animationDuration: Duration(milliseconds: 500),
      animationCurve: Curves.easeInOutBack,
      children: [
        AccordionItem(
          header: Text('Slow & bouncy'),
          content: Text(
            'A longer duration and an easeInOutBack curve give a springy feel.',
          ),
        ),
      ],
    );
  }
}

class NestedDemo extends StatelessWidget {
  const NestedDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return AccordionCustom(
      children: [
        AccordionItem(
          header: const Text('Outer panel'),
          content: AccordionCustom(
            itemSpacing: 6,
            headerStyle: AccordionHeaderStyle(
              backgroundColor: Colors.grey.shade100,
              borderColor: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
            children: const [
              AccordionItem(
                header: Text('Inner one'),
                content: Text('An accordion inside an accordion.'),
              ),
              AccordionItem(
                header: Text('Inner two'),
                content: Text('Nesting works to any depth.'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BuilderDemo extends StatelessWidget {
  const BuilderDemo({super.key});

  static const List<(String, String)> _faqs = [
    ('Shipping', 'We ship worldwide within 3–5 business days.'),
    ('Returns', 'Free returns within 30 days of delivery.'),
    ('Support', 'Reach us any time at support@example.com.'),
  ];

  @override
  Widget build(BuildContext context) {
    return AccordionCustom.builder(
      itemCount: _faqs.length,
      itemBuilder: (context, index) {
        final (question, answer) = _faqs[index];
        return AccordionItem(header: Text(question), content: Text(answer));
      },
    );
  }
}
