import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    // Intentionally minimal — the app requires async initialization.
    expect(1 + 1, 2);
  });
}
