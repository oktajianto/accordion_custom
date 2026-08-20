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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('accordion_custom')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Section('Single mode (default)', BasicSingleDemo()),
          _Section('Multiple mode', MultipleDemo()),
          _Section('Controller: expand / collapse all', ControllerDemo()),
          _Section('Custom colors, border & radius', StyledDemo()),
          _Section('Nested accordion', NestedDemo()),
          _Section('.builder from a data list', BuilderDemo()),
        ],
      ),
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
          content: Text('Yes — colors, borders, radius, padding, and the icon.'),
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
        backgroundColor: Colors.indigo.shade50.withValues(alpha: 0.4),
        dividerColor: Colors.indigo.shade100,
      ),
      children: const [
        AccordionItem(
          header: Text('Fully themed panel'),
          content: Text(
            'Background, border color and width, corner radius, the icon side, '
            'and text style are all set through the style objects.',
          ),
        ),
        AccordionItem(
          header: Text('Second themed panel'),
          content: Text('itemSpacing puts a gap between cards.'),
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
