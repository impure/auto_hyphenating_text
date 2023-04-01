
import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
	TestWidgetsFlutterBinding.ensureInitialized();
	await initHyphenation();

	String getText() {
		expect(find.byType(RichText), findsOneWidget);
		String text = find.byType(RichText).toString();
		text = text.substring(text.indexOf("RichText") + "RichText".length + 1);
		text = text.substring(text.indexOf("\"", text.indexOf("RichText") + "RichText".length + 1) + 1);
		text = text.substring(0, text.indexOf("\""));
		return text;
	}

	// Checks 1e844e8cd0d9b2da0b4f3fc3ceee9df8a85d7f5a
	testWidgets("Zero Width, Should Not Cause An Infinite Loop", (WidgetTester tester) async {
		await tester.pumpWidget(
			const MaterialApp(
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

	testWidgets("Build should be non-mutating", (WidgetTester tester) async {
		AutoHyphenatingText text = const AutoHyphenatingText("The CEO made some controversial statements yesterday.");
		await tester.pumpWidget(
			MaterialApp(
				home: Center(
					child: SizedBox(
						key: const Key("1"),
						width: 700,
						child: text,
					),
				),
			),
		);
		String firstText = getText();
		await tester.pumpWidget(
			MaterialApp(
				home: Center(
					child: SizedBox(
						key: const Key("2"),
						width: 700,
						child: text,
					),
				),
			),
		);
		expect(firstText, getText());
		expect(getText(), "The CEO made\\nsome contro‐\\nversial state‐\\nments yester‐\\nday.");
	});

	group("shouldHyphenate", () {
		testWidgets("No should hyphenate and always hyphenate should be the same", (WidgetTester tester) async {
			await tester.pumpWidget(
				const MaterialApp(
					home: Center(
						child: SizedBox(
							width: 700,
							child: AutoHyphenatingText("The CEO made some controversial statements yesterday."),
						),
					),
				),
			);
			final String noHyphenationGiven = getText();
			await tester.pumpWidget(
				MaterialApp(
					home: Center(
						child: SizedBox(
							width: 700,
							child: AutoHyphenatingText(
								"The CEO made some controversial statements yesterday.",
								shouldHyphenate: (double totalWidth, __, ___) {
									expect(totalWidth, 700);
									return true;
								},
							),
						),
					),
				),
			);
			expect(getText(), noHyphenationGiven);
			expect(getText(), "The CEO made\\nsome contro‐\\nversial state‐\\nments yester‐\\nday.");
		});

		testWidgets("Never hyphenate", (WidgetTester tester) async {
			await tester.pumpWidget(
				MaterialApp(
					home: Center(
						child: SizedBox(
							width: 700,
							child: AutoHyphenatingText(
								"The CEO made some controversial statements yesterday.",
								shouldHyphenate: (double totalWidth, __, ___) {
									expect(totalWidth, 700);
									return false;
								},
							),
						),
					),
				),
			);
			expect(getText(), "The CEO made\\nsome\\ncontroversial\\nstatements\\nyesterday.");
		});

		testWidgets("Only hyphenate long words", (WidgetTester tester) async {
			await tester.pumpWidget(
				MaterialApp(
					home: Center(
						child: SizedBox(
							width: 500,
							child: AutoHyphenatingText(
								"The CEO made some controversial statements yesterday.",
								shouldHyphenate: (double totalWidth, __, double wordWidth) {
									expect(totalWidth, 500);
									return wordWidth > 400;
								},
							),
						),
					),
				),
			);
			expect(getText(), "The CEO\\nmade some\\ncontrover‐\\nsial\\nstatements\\nyesterday.");
		});

		testWidgets("Max lines given", (WidgetTester tester) async {
			await tester.pumpWidget(
				MaterialApp(
					home: Center(
						child: SizedBox(
							width: 500,
							child: AutoHyphenatingText(
								"The CEO made some controversial statements yesterday.",
								maxLines: 2,
								shouldHyphenate: (double totalWidth, __, double wordWidth) {
									expect(totalWidth, 500);
									return wordWidth > 400;
								},
							),
						),
					),
				),
			);
			expect(getText(), "The CEO\\nmade some");
		});

		testWidgets("Don't insert redundant hyphens", (WidgetTester tester) async {
			await tester.pumpWidget(
				const MaterialApp(
					home: Center(
						child: SizedBox(
							width: 400,
							child: AutoHyphenatingText(
								"And it would make it much more suitable for mission-critical applications.",
							),
						),
					),
				),
			);
			expect(getText(), r"And it\nwould\nmake it\nmuch\nmore\nsuitable\nfor mis‐\nsion-\ncritical\napplica‐\ntions.");
		});

		testWidgets("Only hyphenate words if not starting a line with them", (WidgetTester tester) async {
			await tester.pumpWidget(
				const MaterialApp(
					home: Center(
						child: SizedBox(
							width: 300,
							child: AutoHyphenatingText(
								"A buffalo buffalo can buffalo buffalo buffalo",
							),
						),
					),
				),
			);
			expect(getText(), "A buf‐\\nfalo\\nbuf‐\\nfalo\\ncan\\nbuf‐\\nfalo\\nbuf‐\\nfalo\\nbuf‐\\nfalo");
			await tester.pumpWidget(
				MaterialApp(
					home: Center(
						child: SizedBox(
							width: 300,
							child: AutoHyphenatingText(
								"A buffalo buffalo can buffalo buffalo buffalo",
								shouldHyphenate: (double totalWidth, double currentLineWidth, _) {
									expect(totalWidth, 300);
									return currentLineWidth != 0;
								},
							),
						),
					),
				),
			);
			expect(getText(), "A buf‐\\nfalo\\nbuffalo\\ncan\\nbuffalo\\nbuffalo\\nbuffalo");
		});
	});

	testWidgets("Throws assertion error if not initialized", (WidgetTester tester) async {
		globalLoader = null;
		await tester.pumpWidget(
			const MaterialApp(
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
			const MaterialApp(
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
			const MaterialApp(
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
			const MaterialApp(
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
			const MaterialApp(
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

	testWidgets("Should Use Correct Semantics", (WidgetTester tester) async {
		await tester.pumpWidget(
			const MaterialApp(
				home: Center(
					child: SizedBox(
						width: 400,
						child: Text("How much wood could a woodchuck chuck if a woodchuck could chuck wood?"),
					),
				),
			),
		);
		final SemanticsNode textNode = tester.getSemantics(find.byType(RichText));
		await tester.pumpWidget(
			const MaterialApp(
				home: Center(
					child: SizedBox(
						width: 400,
						child: AutoHyphenatingText("How much wood could a woodchuck chuck if a woodchuck could chuck wood?"),
					),
				),
			),
		);
		expect(tester.getSemantics(find.byType(RichText)).label, "How much wood could a woodchuck chuck if a woodchuck could chuck wood?");
		expect(textNode.label, tester.getSemantics(find.byType(RichText)).label);
	});
}
