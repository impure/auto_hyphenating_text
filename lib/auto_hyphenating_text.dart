
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hyphenator_impure/hyphenator.dart';

ResourceLoader? globalLoader;

Future<void> initHyphenation([DefaultResourceLoaderLanguage language = DefaultResourceLoaderLanguage.enUs]) async {
	globalLoader = await DefaultResourceLoader.load(language);
}

class AutoHyphenatingText extends StatelessWidget {
	factory AutoHyphenatingText(
		String text, {
		ResourceLoader? loader,
		TextStyle? style,
		TextAlign? textAlign,
		StrutStyle? strutStyle,
		TextDirection? textDirection,
		Locale? locale,
		bool? softWrap,
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
			loader: loader,
			style: style,
			strutStyle: strutStyle,
			textAlign: textAlign,
			textDirection: textDirection,
			overflow: overflow,
			locale: locale,
			softWrap: softWrap,
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
		this.loader,
		this.style,
		this.strutStyle,
		this.textAlign,
		this.textDirection,
		this.locale,
		this.softWrap,
		this.overflow,
		this.textScaleFactor,
		this.maxLines,
		this.semanticsLabel,
		this.textWidthBasis,
		this.selectionColor,
		super.key,
	});

	final String text;
	final ResourceLoader? loader;
	final List<String> words;
	final TextStyle? style;
	final TextAlign? textAlign;
	final StrutStyle? strutStyle;
	final TextDirection? textDirection;
	final Locale? locale;
	final bool? softWrap;
	final TextOverflow? overflow;
	final double? textScaleFactor;
	final int? maxLines;
	final String? semanticsLabel;
	final TextWidthBasis? textWidthBasis;
	final Color? selectionColor;

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

		double getTextWidth(String text, TextStyle? style, TextDirection? direction, double? scaleFactor) {
			final TextPainter textPainter = TextPainter(
				text: TextSpan(text: text, style: style),
				textScaleFactor: scaleFactor ?? MediaQuery.of(context).textScaleFactor,
				maxLines: 1,
				textDirection: direction ?? Directionality.of(context),
			)..layout();
			return textPainter.size.width;
		}

		int? getLastSyllableIndex(List<String> syllables, double availableSpace, TextStyle? effectiveTextStyle) {

			if (getTextWidth(mergeSyllablesFront(syllables, 0), effectiveTextStyle, textDirection, textScaleFactor) > availableSpace) {
				return null;
			}

			int lowerBound = 0;
			int upperBound = syllables.length;

			while (lowerBound != upperBound - 1) {
				int testIndex = ((lowerBound + upperBound) * 0.5).floor();

				if (getTextWidth(mergeSyllablesFront(syllables, testIndex), effectiveTextStyle, textDirection, textScaleFactor) > availableSpace) {
					upperBound = testIndex;
				} else {
					lowerBound = testIndex;
				}
			}

			return lowerBound;
		}

		final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
		TextStyle? effectiveTextStyle = style;
		if (style == null || style!.inherit) {
			effectiveTextStyle = defaultTextStyle.style.merge(style);
		}
		if (MediaQuery.boldTextOverride(context)) {
			effectiveTextStyle = effectiveTextStyle!.merge(const TextStyle(fontWeight: FontWeight.bold));
		}

		return LayoutBuilder(
				builder: (BuildContext context, BoxConstraints constraints) {

			List<InlineSpan> texts = <InlineSpan>[];

			assert(globalLoader != null, "AutoHyphenatingText not initialized! Remember to call initHyphenation().");
			final Hyphenator hyphenator = Hyphenator(
				resource: loader ?? globalLoader!,
				hyphenateSymbol: '_',
			);

			double singleSpaceWidth = getTextWidth(" ", effectiveTextStyle, textDirection, textScaleFactor);
			double currentLineSpaceUsed = 0;
			int lines = 0;

			for (int i = 0; i < words.length; i++) {

				double wordWidth = getTextWidth(words[i], effectiveTextStyle, textDirection, textScaleFactor);

				if (currentLineSpaceUsed + wordWidth < constraints.maxWidth) {
					texts.add(TextSpan(text: words[i]));
					currentLineSpaceUsed += wordWidth;
				} else {

					final List<String> syllables = words[i].length == 1 ? <String>[words[i]] : hyphenator.hyphenateWordToList(words[i]);
					final int? syllableToUse = words[i].length == 1 ? null : getLastSyllableIndex(syllables, constraints.maxWidth - currentLineSpaceUsed, effectiveTextStyle);

					if (syllableToUse == null) {
						if (currentLineSpaceUsed == 0) {
							texts.add(TextSpan(text: words[i]));
							currentLineSpaceUsed += wordWidth;
						} else {
							i--;
							if (texts.last == const TextSpan(text: " ")) {
								texts.removeLast();
							}
							texts.add(const TextSpan(text: "\n"));
							currentLineSpaceUsed = 0;
							lines++;
							if (maxLines != null && lines >= maxLines!) {
								break;
							}
						}
						continue;
					} else {
						texts.add(TextSpan(text: mergeSyllablesFront(syllables, syllableToUse)));
						words.insert(i + 1, mergeSyllablesBack(syllables, syllableToUse));
						currentLineSpaceUsed = 0;
						texts.add(const TextSpan(text: "\n"));
						if (maxLines != null && lines >= maxLines!) {
							break;
						}
						continue;
					}
				}

				if (i != words.length - 1) {
					if (currentLineSpaceUsed + singleSpaceWidth < constraints.maxWidth) {
						texts.add(const TextSpan(text: " "));
						currentLineSpaceUsed += singleSpaceWidth;
					} else {
						if (texts.last == const TextSpan(text: " ")) {
							texts.removeLast();
						}
						texts.add(const TextSpan(text: "\n"));
						currentLineSpaceUsed = 0;
						lines++;
						if (maxLines != null && lines >= maxLines!) {
							break;
						}
					}
				}
			}

			final SelectionRegistrar? registrar = SelectionContainer.maybeOf(context);
			Widget text = RichText(
				textDirection: textDirection,
				strutStyle: strutStyle,
				locale: locale,
				softWrap: softWrap ?? true,
				overflow: overflow ?? TextOverflow.clip,
				textScaleFactor: textScaleFactor ?? MediaQuery.of(context).textScaleFactor,
				textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
				selectionColor: selectionColor,
				textAlign: textAlign ?? TextAlign.start,
				selectionRegistrar: registrar,
				text: TextSpan(
					style: effectiveTextStyle,
					children: texts,
				),
			);

			if (registrar != null) {
				text = MouseRegion(
					cursor: SystemMouseCursors.text,
					child: text,
				);
			}
			if (semanticsLabel != null) {
				text = Semantics(
					textDirection: textDirection,
					label: semanticsLabel,
					child: ExcludeSemantics(
						child: text,
					),
				);
			}
			return text;
		});
	}
}
