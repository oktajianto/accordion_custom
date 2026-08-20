import 'package:accordion_custom/accordion_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child)));

void main() {
  group('AccordionCustom', () {
    testWidgets('tapping a header expands and collapses it', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AccordionCustom(
            children: [
              AccordionItem(header: Text('Head A'), content: Text('Body A')),
            ],
          ),
        ),
      );

      expect(find.text('Body A'), findsNothing);

      await tester.tap(find.text('Head A'));
      await tester.pumpAndSettle();
      expect(find.text('Body A'), findsOneWidget);

      await tester.tap(find.text('Head A'));
      await tester.pumpAndSettle();
      expect(find.text('Body A'), findsNothing);
    });

    testWidgets('single mode closes the previously open panel', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AccordionCustom(
            mode: AccordionMode.single,
            children: [
              AccordionItem(header: Text('Head A'), content: Text('Body A')),
              AccordionItem(header: Text('Head B'), content: Text('Body B')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Head A'));
      await tester.pumpAndSettle();
      expect(find.text('Body A'), findsOneWidget);

      await tester.tap(find.text('Head B'));
      await tester.pumpAndSettle();
      expect(find.text('Body A'), findsNothing);
      expect(find.text('Body B'), findsOneWidget);
    });

    testWidgets('multiple mode keeps panels independent', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AccordionCustom(
            mode: AccordionMode.multiple,
            children: [
              AccordionItem(header: Text('Head A'), content: Text('Body A')),
              AccordionItem(header: Text('Head B'), content: Text('Body B')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Head A'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Head B'));
      await tester.pumpAndSettle();

      expect(find.text('Body A'), findsOneWidget);
      expect(find.text('Body B'), findsOneWidget);
    });

    testWidgets('initiallyExpanded opens a panel on first build', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const AccordionCustom(
            children: [
              AccordionItem(
                header: Text('Head A'),
                content: Text('Body A'),
                initiallyExpanded: true,
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Body A'), findsOneWidget);
    });

    testWidgets('per-item style overrides the accordion style', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AccordionCustom(
            headerStyle: AccordionHeaderStyle(backgroundColor: Colors.blue),
            children: [
              AccordionItem(header: Text('Default'), content: Text('a')),
              AccordionItem(
                header: Text('Overridden'),
                content: Text('b'),
                headerStyle: AccordionHeaderStyle(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      );

      Color? inkColor(String label) {
        final ink = tester.widget<Ink>(
          find.ancestor(of: find.text(label), matching: find.byType(Ink)),
        );
        return (ink.decoration as BoxDecoration?)?.color;
      }

      expect(inkColor('Default'), Colors.blue);
      expect(inkColor('Overridden'), Colors.red);
    });

    testWidgets('disabled panel ignores taps', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AccordionCustom(
            children: [
              AccordionItem(
                header: Text('Head A'),
                content: Text('Body A'),
                enabled: false,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Head A'));
      await tester.pumpAndSettle();
      expect(find.text('Body A'), findsNothing);
    });
  });

  group('AccordionController', () {
    testWidgets('drives expand/collapse and reports state', (tester) async {
      final controller = AccordionController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _wrap(
          AccordionCustom(
            mode: AccordionMode.multiple,
            controller: controller,
            children: const [
              AccordionItem(header: Text('Head A'), content: Text('Body A')),
              AccordionItem(header: Text('Head B'), content: Text('Body B')),
            ],
          ),
        ),
      );

      controller.expandAll();
      await tester.pumpAndSettle();
      expect(controller.expandedIndexes, {0, 1});
      expect(find.text('Body A'), findsOneWidget);
      expect(find.text('Body B'), findsOneWidget);

      controller.collapse(0);
      await tester.pumpAndSettle();
      expect(controller.isExpanded(0), isFalse);
      expect(find.text('Body A'), findsNothing);

      controller.collapseAll();
      await tester.pumpAndSettle();
      expect(controller.expandedIndexes, isEmpty);
    });

    testWidgets('single mode keeps only one panel open via controller', (
      tester,
    ) async {
      final controller = AccordionController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _wrap(
          AccordionCustom(
            controller: controller,
            children: const [
              AccordionItem(header: Text('Head A'), content: Text('Body A')),
              AccordionItem(header: Text('Head B'), content: Text('Body B')),
            ],
          ),
        ),
      );

      controller.expand(0);
      controller.expand(1);
      await tester.pumpAndSettle();
      expect(controller.expandedIndexes, {1});

      controller.expandAll(); // no-op in single mode
      expect(controller.expandedIndexes, {1});
    });
  });
}
