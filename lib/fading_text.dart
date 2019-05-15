library fading_text;

import 'package:flutter/material.dart';

/// Adds fading effect on each character in the [text] provided to it.
///
/// The animation is repeated continuously so this widget is ideal
/// to be used as progress indicator.
/// Although this widget does not put explicit limit on string character count,
/// however, it should be given such that it does not exceed a line.
///
/// The text displayed follows the default [TextStyle] of current theme.
class FadingText extends StatefulWidget {
  /// Text to animate
  final String text;

  /// Creates a fading continuous animation.
  ///
  /// The provided [text] is continuously animated using [FadeTransition].
  /// [text] must not be null.
  FadingText(this.text) : assert(text != null);

  @override
  _FadingTextState createState() => _FadingTextState();
}

class _FadingTextState extends State<FadingText> with TickerProviderStateMixin {
  final _characters = <MapEntry<String, Animation>>[];
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    var start = 0.2;
    final duration = 0.6 / widget.text.length;
    widget.text.runes.forEach((int rune) {
      final character = String.fromCharCode(rune);
      final animation = Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          curve: Interval(start, start + duration, curve: Curves.easeInOut),
          parent: _controller,
        ),
      );
      _characters.add(MapEntry(character, animation));
      start += duration;
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _characters
          .map(
            (entry) => FadeTransition(
          opacity: entry.value,
          child: Text(entry.key),
        ),
      )
          .toList(),
    );
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}
