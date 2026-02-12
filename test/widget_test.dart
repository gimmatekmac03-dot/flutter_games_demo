import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_games_demo/main.dart';

void main() {
  testWidgets('renders difficulty home page', (WidgetTester tester) async {
    await tester.pumpWidget(const SeniorGamesApp());
    expect(find.text('長者趣味闖關'), findsOneWidget);
    expect(find.text('簡易模式'), findsOneWidget);
    expect(find.text('普通模式'), findsOneWidget);
  });
}
