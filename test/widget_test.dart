import 'package:decast/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Weather app builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
