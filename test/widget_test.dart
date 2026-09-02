import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waro_marketplace_app/main.dart';

void main() {
  testWidgets('WaroApp builds', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: WaroApp()));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
