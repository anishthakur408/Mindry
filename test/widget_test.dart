import 'package:flutter_test/flutter_test.dart';
import 'package:mindflow/main.dart';

void main() {
  testWidgets('MindFlow app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MindFlowApp());

    // Verify that the app starts
    expect(find.text('MindFlow'), findsWidgets);
  });
}
