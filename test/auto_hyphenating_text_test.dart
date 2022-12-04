
import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
	TestWidgetsFlutterBinding.ensureInitialized();
	await initHyphenation();

	// Checks 1e844e8cd0d9b2da0b4f3fc3ceee9df8a85d7f5a
	testWidgets("Zero Width, Should Not Cause An Infinite Loop", (WidgetTester tester) async {
		await tester.pumpWidget(
			MaterialApp(
				home: Center(
					child: SizedBox(
						width: 0,
						child: AutoHyphenatingText("Hello"),
					),
				),
			),
		);
		expect(find.byType(RichText).toString().contains("Hello"), true);
	});

	testWidgets("Small Lines, Should Not Cause An Infinite Loop", (WidgetTester tester) async {
		await tester.pumpWidget(
			MaterialApp(
				home: Center(
					child: SizedBox(
						width: 100,
						child: AutoHyphenatingText("How much wood could a woodchuck chuck if a woodchuck could chuck wood?"),
					),
				),
			),
		);
	});
}
