import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('gallery builds and toggles a panel', (tester) async {
    await tester.pumpWidget(const DemoApp());

    expect(find.text('What is accordion_custom?'), findsOneWidget);

    await tester.tap(find.text('What is accordion_custom?'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('A zero-dependency, fully customizable accordion'),
      findsOneWidget,
    );
  });
}
