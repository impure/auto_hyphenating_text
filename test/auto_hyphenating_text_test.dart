
import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {

	TestWidgetsFlutterBinding.ensureInitialized();
	await initHyphenation();

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
	});
}
