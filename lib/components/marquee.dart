import 'package:flutter/material.dart';

class Marquee extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double velocity;
  final double blankSpace;

  const Marquee({
    required this.text,
    required this.style,
    this.velocity = 20,
    this.blankSpace = 20,
    super.key,
  });

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (widget.text.length / widget.velocity).round()),
    )..repeat();

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1, 0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textWidth = _textSize(widget.text, widget.style).width;
        if (textWidth <= constraints.maxWidth) {
          return Text(widget.text, style: widget.style);
        }
        return SizedBox(
          height: _textSize(widget.text, widget.style).height,
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: _animation.value * (textWidth + widget.blankSpace),
                      child: child,
                    );
                  },
                  child: Text(
                    '${widget.text}${' ' * 10}${widget.text}',
                    style: widget.style,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }
}