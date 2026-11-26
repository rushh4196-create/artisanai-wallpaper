// ARTISANAI smoke test — Aurora Glass Gallery UI.
// Verifies the app boots, shows the hero + Today's Drop bento grid,
// and the floating glass nav.
import 'package:flutter_test/flutter_test.dart';

import 'package:artisanai_wallpaper/main.dart';

void main() {
  testWidgets('ARTISANAI home shows Today\'s Drop', (WidgetTester tester) async {
    await tester.pumpWidget(const ArtisanAiApp());
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('ARTISANAI'), findsOneWidget);
    // Hero is the live portrait wallpaper.
    expect(find.text('Mist Over the Valley'), findsOneWidget);
    // Bento grid tiles are below the fold — scroll them into view.
    await tester.scrollUntilVisible(
      find.text("Today's Drop"),
      300,
    );
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text("Today's Drop"), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Golden Valley at Dawn'),
      300,
    );
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Golden Valley at Dawn'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Golden Valley — Portrait'),
      300,
    );
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Golden Valley — Portrait'), findsOneWidget);
    // Floating glass nav: Today is the active pill.
    expect(find.text('Today'), findsOneWidget);
  });
}
