import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:flutter/material.dart';
import 'package:hyphenator_impure/hyphenator.dart';

void main() {
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Auto Hyphenating Text Demo',
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: const GermanExample(title: 'Auto Hyphenating Text Demo'),
		);
	}
}

class GermanExample extends StatefulWidget {
	const GermanExample({super.key, required this.title});

	final String title;

	@override
	State<GermanExample> createState() => _GermanExampleState();
}

class _GermanExampleState extends State<GermanExample> {

	@override
	void initState() {
		super.initState();
		initHyphenation(DefaultResourceLoaderLanguage.de1996);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.title),
			),
			body: Center(
				child: AutoHyphenatingText('Ändern Sie die Größe dieses Fensters, um die automatische Silbentrennung in Aktion zu sehen.', style: Theme.of(context).textTheme.titleLarge),
			),
		);
	}
}

class EnglishExample extends StatefulWidget {
	const EnglishExample({super.key, required this.title});

	final String title;

	@override
	State<EnglishExample> createState() => _EnglishExampleState();
}

class _EnglishExampleState extends State<EnglishExample> {

	@override
	void initState() {
		super.initState();
		initHyphenation();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.title),
			),
			body: Center(
				child: AutoHyphenatingText('Resize this window to see autohyphenating text in action.', style: Theme.of(context).textTheme.titleLarge),
			),
		);
	}
}
