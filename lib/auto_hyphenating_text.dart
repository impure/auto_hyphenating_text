
import 'package:flutter/material.dart';
import 'package:hyphenator/hyphenator.dart';

ResourceLoader? loader;

Future<void> initHyphenation([DefaultResourceLoaderLanguage language = DefaultResourceLoaderLanguage.enUs]) async {
	loader = await DefaultResourceLoader.load(language);
}

class AutoHyphenatingText extends StatefulWidget {
	factory AutoHyphenatingText(
		String text, {
		TextStyle? style,
		TextAlign? textAlign,
		StrutStyle? strutStyle,
		TextDirection? textDirection,
		//final Locale? locale;
		//final bool? softWrap;
		TextOverflow? overflow,
		double? textScaleFactor,
		int? maxLines,
		String? semanticsLabel,
		TextWidthBasis? textWidthBasis,
		Color? selectionColor,
		Key? key,
	}) {
		return AutoHyphenatingText._(
			text: text,
			words: text.split(" "),
			style: style,
			strutStyle: strutStyle,
			textAlign: textAlign,
			textDirection: textDirection,
			overflow: overflow,
			textScaleFactor: textScaleFactor,
			maxLines: maxLines,
			semanticsLabel: semanticsLabel,
			textWidthBasis: textWidthBasis,
			selectionColor: selectionColor,
			key: key,
		);
	}

	const AutoHyphenatingText._({
		required this.text,
		required this.words,
		this.style,
		this.strutStyle,
		this.textAlign,
		this.textDirection,
		//this.locale,
		//this.softWrap,
		this.overflow,
		this.textScaleFactor,
		this.maxLines,
		this.semanticsLabel,
		this.textWidthBasis,
		this.selectionColor,
		super.key,
	});

	final String text;
	final List<String> words;
	final TextStyle? style;
	final TextAlign? textAlign;
	final StrutStyle? strutStyle;
	final TextDirection? textDirection;

	//final Locale? locale;
	//final bool? softWrap;
	final TextOverflow? overflow;
	final double? textScaleFactor;
	final int? maxLines;
	final String? semanticsLabel;
	final TextWidthBasis? textWidthBasis;
	final Color? selectionColor;

	@override
	State<AutoHyphenatingText> createState() => _AutoHyphenatingTextState();
}

class _AutoHyphenatingTextState extends State<AutoHyphenatingText> {

	 double getTextWidth(String text, TextStyle? style, TextDirection? direction, double? scaleFactor) {
		final TextPainter textPainter = TextPainter(
			 text: TextSpan(text: text, style: style),
			 textScaleFactor: scaleFactor ?? MediaQuery.of(context).textScaleFactor,
			 maxLines: 1,
			 textDirection: direction ?? Directionality.of(context),
		)..layout();
		return textPainter.size.width;
	}

	String mergeSyllablesFront(List<String> syllables, int indicesToMergeInclusive) {
		 StringBuffer buffer = StringBuffer();

		 for (int i = 0; i <= indicesToMergeInclusive; i++) {
			 buffer.write(syllables[i]);
		 }

		 buffer.write("‐");
		 return buffer.toString();
	}

	 String mergeSyllablesBack(List<String> syllables, int indicesToMergeInclusive) {
		 StringBuffer buffer = StringBuffer();

		 for (int i = indicesToMergeInclusive + 1; i < syllables.length; i++) {
			 buffer.write(syllables[i]);
		 }

		 return buffer.toString();
	 }

	@override
	Widget build(BuildContext context) {
		return LayoutBuilder(
				builder: (BuildContext context, BoxConstraints constraints) {

			List<InlineSpan> texts = <InlineSpan>[];

			final Hyphenator hyphenator = Hyphenator(
				resource: loader!,
				hyphenateSymbol: '_',
			);

			double singleSpaceWidth = getTextWidth(" ", widget.style, widget.textDirection, widget.textScaleFactor);
			double currentLineSpaceUsed = 0;

			for (int i = 0; i < widget.words.length; i++) {

				double textWidth = getTextWidth(widget.words[i], widget.style, widget.textDirection, widget.textScaleFactor);

				if (currentLineSpaceUsed + textWidth < constraints.maxWidth) {
					texts.add(TextSpan(text: widget.words[i]));
					currentLineSpaceUsed += textWidth;
				} else {
					List<String> syllables = hyphenator.hyphenateWordToList(widget.words[i]);
					int? syllableToUse;

					for (int i = 0; i < syllables.length; i++) {
						if (currentLineSpaceUsed + getTextWidth(mergeSyllablesFront(syllables, i), widget.style, widget.textDirection, widget.textScaleFactor) < constraints.maxWidth) {
							syllableToUse = i;
						} else {
							break;
						}
					}

					if (syllableToUse == null) {
						texts.add(TextSpan(text: widget.words[i]));
						currentLineSpaceUsed = textWidth;
					} else {
						texts.add(TextSpan(text: mergeSyllablesFront(syllables, syllableToUse)));
						widget.words.insert(i + 1, mergeSyllablesBack(syllables, syllableToUse));
						currentLineSpaceUsed = 0;
						texts.add(const TextSpan(text: "\n"));
					}
				}

				if (currentLineSpaceUsed + singleSpaceWidth < constraints.maxWidth) {
					texts.add(const TextSpan(text: " "));
					currentLineSpaceUsed += singleSpaceWidth;
				} else {
					texts.add(const TextSpan(text: "\n"));
					currentLineSpaceUsed = 0;
				}
			}

			return RichText(
				textAlign: widget.textAlign ?? TextAlign.start,
				text: TextSpan(
					style: widget.style,
					children: texts,
				),
			);
		});
		return Text(
			widget.text,
			style: widget.style,
			textAlign: widget.textAlign,
			strutStyle: widget.strutStyle,
			textDirection: widget.textDirection,
			overflow: widget.overflow,
			textScaleFactor: widget.textScaleFactor,
			maxLines: widget.maxLines,
			semanticsLabel: widget.semanticsLabel,
			selectionColor: widget.selectionColor,
		);
	}
}
