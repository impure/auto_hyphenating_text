
import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:state_groups/state_groups.dart';

void main() async {
	TestWidgetsFlutterBinding.ensureInitialized();
	await initHyphenation();

	String getText() {
		String text = find.byType(RichText).toString();
		text = text.substring(text.indexOf("RichText") + "RichText".length + 1);
		text = text.substring(text.indexOf("\"", text.indexOf("RichText") + "RichText".length + 1) + 1);
		text = text.substring(0, text.indexOf("\""));
		return text;
	}

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
		expect(getText(), "Hello");
	});

	testWidgets("Throws assertion error if not initialized", (WidgetTester tester) async {
		globalLoader = null;
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
		expect(tester.takeException(), isAssertionError);
		await initHyphenation();
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

	// Checks 274869ad6f4323e12005301c6b4916f5f0233ba2
	testWidgets("Small Lines, Should Hyphenate 'Woodchuck'", (WidgetTester tester) async {
		await tester.pumpWidget(
			MaterialApp(
				home: Center(
					child: SizedBox(
						width: 400,
						child: AutoHyphenatingText("How much wood could a woodchuck chuck if a woodchuck could chuck wood?"),
					),
				),
			),
		);
		expect(getText().contains("wood‐"), true);
		expect(getText(), "How much\\nwood\\ncould a\\nwood‐\\nchuck\\nchuck if\\na wood‐\\nchuck\\ncould\\nchuck\\nwood?");
	});

	testWidgets("No Extra Space At The End", (WidgetTester tester) async {
		await tester.pumpWidget(
			MaterialApp(
				home: Center(
					child: SizedBox(
						width: 100,
						child: AutoHyphenatingText(""),
					),
				),
			),
		);
		expect(getText(), "");
	});

	testWidgets("Should Not Generate Extra Newlines", (WidgetTester tester) async {
		await tester.pumpWidget(
			MaterialApp(
				home: Center(
					child: SizedBox(
						width: 300,
						child: AutoHyphenatingText("pneumonoultramicroscopicvolcanoiosis"),
					),
				),
			),
		);
		expect(getText().replaceAll(" ", "").contains("\\n\\n"), false);
	});
}
