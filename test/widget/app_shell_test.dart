import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productivity_hub/core/routing/app_shell.dart';

void main() {
  testWidgets('shows bottom navigation with three tabs', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AppShell(
            pages: [
              Placeholder(),
              Placeholder(),
              Placeholder(),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Tasks'), findsNWidgets(2));
    expect(find.text('Habits'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
  });
}
