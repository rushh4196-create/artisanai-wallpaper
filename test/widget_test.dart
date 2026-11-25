// ARTISANAI smoke test — Phase 0.
// Verifies the app boots and shows Today's Drop with its three cards.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:artisanai_wallpaper/main.dart';

void main() {
  testWidgets('ARTISANAI home shows Today\'s Drop', (WidgetTester tester) async {
    await tester.pumpWidget(const ArtisanAiApp());

    expect(find.text('ARTISANAI'), findsOneWidget);
    expect(find.text("Today's Drop"), findsOneWidget);
    expect(find.text('Golden Valley at Dawn'), findsOneWidget);
    // Portrait + live cards are below the fold in the test viewport —
    // scroll them into view before asserting.
    await tester.scrollUntilVisible(
      find.text('Golden Valley — Portrait'),
      300,
    );
    await tester.pumpAndSettle();
    expect(find.text('Golden Valley — Portrait'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Mist Over the Valley'),
      300,
    );
    await tester.pumpAndSettle();
    expect(find.text('Mist Over the Valley'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
