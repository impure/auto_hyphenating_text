import 'package:flutter/widgets.dart';

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

	AutoHyphenatingText._({
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

	@override
	Widget build(BuildContext context) {
		return LayoutBuilder(
				builder: (BuildContext context, BoxConstraints constraints) {

					/*
			double? bestDeviation;
			double? bestWidth;
			int? numLines;

			for (double currentWidth = constraints.maxWidth;
					currentWidth > 0;
					currentWidth--) {
				final List<double> widths = <double>[0];

				for (int dataIndex = 0; dataIndex < textData.length; dataIndex++) {
					if (widths.last != 0 &&
							widths.last + textData[dataIndex].width > currentWidth) {
						// This fixes an issue when a line has a single space character and nothing else (due to an overflow)
						if (dataIndex != 0 &&
								textData[dataIndex - 1].isSpace &&
								widths.last == textData[dataIndex - 1].width) {
							widths.removeLast();
							texts.removeAt(dataIndex - 1);
							textData.removeAt(dataIndex - 1);
							dataIndex--;
						}

						widths.add(0);
					}
					widths.last += textData[dataIndex].width;

					// Penalty for making the line overflow (extra blank line)
					if (widths.last > currentWidth) {
						widths.add(0);
						widths.add(0);
					}
				}

				// Only consider lines with the highest possible number of lines
				if (numLines == null) {
					numLines = widths.length;
				} else if (numLines < widths.length) {
					break;
				}

				final double currentStandardDeviation = getStandardDeviation(widths);
				//print(currentStandardDeviation);
				if (bestDeviation == null || currentStandardDeviation < bestDeviation) {
					bestDeviation = currentStandardDeviation;
					bestWidth = currentWidth;
				}
			}
			 */

			List<InlineSpan> texts = <InlineSpan>[];

			double singleSpaceWidth = getTextWidth(" ", widget.style, widget.textDirection, widget.textScaleFactor);
			double currentLineSpaceUsed = 0;

			for (int i = 0; i < widget.words.length; i++) {

				double textWidth = getTextWidth(widget.words[i], widget.style, widget.textDirection, widget.textScaleFactor);

				if (currentLineSpaceUsed + textWidth < constraints.maxWidth) {
					texts.add(TextSpan(text: widget.words[i]));
					currentLineSpaceUsed += textWidth;
				} else {
					texts.add(TextSpan(text: widget.words[i]));
					//texts.add(TextSpan(text: "\n"));
					//texts.add(WidgetSpan(child: SizedBox(width: constraints.maxWidth - currentLineSpaceUsed)));
					currentLineSpaceUsed = 0;
				}

				if (currentLineSpaceUsed + singleSpaceWidth < constraints.maxWidth) {
					texts.add(TextSpan(text: " "));
					currentLineSpaceUsed += singleSpaceWidth;
				} else {
					//texts.add(TextSpan(text: "\n"));
					texts.add(WidgetSpan(child: SizedBox(width: constraints.maxWidth - currentLineSpaceUsed)));
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
