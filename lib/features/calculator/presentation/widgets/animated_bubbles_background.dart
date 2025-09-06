import 'dart:math';
import 'package:flutter/material.dart';

class Bubble {
  Offset position;
  double radius;
  double speed;
  Color color;
  bool popping;
  double popProgress;

  Bubble({
    required this.position,
    required this.radius,
    required this.speed,
    required this.color,
    this.popping = false,
    this.popProgress = 0,
  });
}

class AnimatedBubblesBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBubblesBackground({super.key, required this.child});

  @override
  State<AnimatedBubblesBackground> createState() =>
      _AnimatedBubblesBackgroundState();
}

class _AnimatedBubblesBackgroundState extends State<AnimatedBubblesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Bubble> _bubbles = [];
  final int _bubbleCount = 18;
  final Random _rnd = Random();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 60))
          ..addListener(_tick)
          ..repeat();
  }

  Bubble _randomBubble({
    double? y,
    required double width,
    required double height,
  }) {
    final side = width > 700 ? 180.0 : 90.0;
    final testColors = [
      Colors.cyanAccent.withValues(alpha: 0.45),
      Colors.blueAccent.withValues(alpha: 0.38),
      Colors.lightBlue.withValues(alpha: 0.42),
      Colors.white.withValues(alpha: 0.55),
    ];
    return Bubble(
      position: Offset(
        _rnd.nextBool()
            ? _rnd.nextDouble() * side
            : width - _rnd.nextDouble() * side,
        y ?? (height * 0.5 + _rnd.nextDouble() * height * 0.5),
      ),
      radius: 38 + _rnd.nextDouble() * 38,
      speed: 0.4 + _rnd.nextDouble() * 0.7,
      color: testColors[_rnd.nextInt(testColors.length)],
    );
  }

  void _tick() {
    if (!mounted) return;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    setState(() {
      for (final b in _bubbles) {
        if (b.popping) {
          b.popProgress += 0.04;
          if (b.popProgress >= 1) {
            final idx = _bubbles.indexOf(b);
            _bubbles[idx] = _randomBubble(
              y: height + 40,
              width: width,
              height: height,
            );
          }
        } else {
          b.position = b.position.translate(0, -b.speed);
          if (b.position.dy + b.radius < -40) {
            final idx = _bubbles.indexOf(b);
            _bubbles[idx] = _randomBubble(
              y: height + 40,
              width: width,
              height: height,
            );
          }
        }
      }
    });
  }

  // width переменная была неиспользуемой, удалена

  void _onTapDown(TapDownDetails details) {
    for (final b in _bubbles) {
      if (!b.popping &&
          (b.position - details.localPosition).distance < b.radius) {
        setState(() {
          b.popping = true;
          b.popProgress = 0;
        });
        break;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    if (!_initialized && width > 0 && height > 0) {
      _bubbles.clear();
      for (int i = 0; i < _bubbleCount; i++) {
        _bubbles.add(_randomBubble(width: width, height: height));
      }
      _initialized = true;
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
      child: CustomPaint(
        painter: _BubblesPainter(_bubbles),
        child: widget.child,
      ),
    );
  }
}

class _BubblesPainter extends CustomPainter {
  final List<Bubble> bubbles;

  _BubblesPainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in bubbles) {
      final paint =
          Paint()
            ..color = b.color
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      final borderPaint =
          Paint()
            ..color = Colors.white.withValues(alpha: 0.7)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5;
      if (b.popping) {
        final scale = 1 + b.popProgress * 1.5;
        final opacity = (1 - b.popProgress).clamp(0.0, 1.0);
        paint.color = paint.color.withValues(alpha: paint.color.a * opacity);
        canvas.drawCircle(b.position, b.radius * scale, paint);
        canvas.drawCircle(b.position, b.radius * scale, borderPaint);
      } else {
        canvas.drawCircle(b.position, b.radius, paint);
        canvas.drawCircle(b.position, b.radius, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BubblesPainter oldDelegate) => true;
}
