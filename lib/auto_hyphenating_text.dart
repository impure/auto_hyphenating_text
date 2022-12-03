
import 'package:flutter/widgets.dart';

class AutoHyphenatingText extends StatefulWidget {
	const AutoHyphenatingText(
		this.text, {
			super.key,
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
		});

  final String text;
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
	@override
	Widget build(BuildContext context) {
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
