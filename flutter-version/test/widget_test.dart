import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:life_balance/app.dart';

void main() {
  testWidgets('App loads with Today tab', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: LifeBalanceApp()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Today'), findsWidgets);
  });
}
