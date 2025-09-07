import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shake_gesture/shake_gesture.dart';
import 'dart:async';

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

  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  double _tiltFactor = 1.0;
  double _smoothTilt = 0.0;
  bool areBubblesDisabled = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 60))
          ..addListener(_tick)
          ..repeat();

    _initAccelerometer();
  }

  void _initAccelerometer() {
    try {
      _accelerometerSubscription = accelerometerEventStream(
        samplingPeriod: const Duration(milliseconds: 100),
      ).listen((AccelerometerEvent event) {
        if (!areBubblesDisabled) {
          double y = event.y;

          double targetTilt;
          if (y.abs() < 2) {
            targetTilt = 4.0;
          } else if (y < -2) {
            targetTilt = 1.5;
          } else {
            targetTilt = 0.5;
          }

          _smoothTilt = _smoothTilt * 0.8 + targetTilt * 0.2;
          _tiltFactor = _smoothTilt;
        } else {
          _tiltFactor = 0.7;
        }

        setState(() {});
      }, onError: (error) {
        print('⚠️ Акселерометр недоступен: $error');
        _tiltFactor = 1.0;
      });
    } catch (e) {
      print('⚠️ Ошибка при инициализации акселерометра: $e');
      _tiltFactor = 1.0;
    }
  }

  Bubble _randomBubble({
    double? y,
    required double width,
    required double height,
  }) {
    final side = width > 700 ? 180.0 : 90.0;
    final List<Color> colors = [
      Colors.cyanAccent.withValues(alpha: 0.45),
      Colors.blueAccent.withValues(alpha: 0.38),
      Colors.lightBlue.withValues(alpha: 0.42),
      Colors.white.withValues(alpha: 0.55),
    ];

    final double bubbleSize = areBubblesDisabled
        ? 50 + _rnd.nextDouble() * 60
        : 38 + _rnd.nextDouble() * 38;
    final double bubbleSpeed = areBubblesDisabled
        ? 0.2 + _rnd.nextDouble() * 0.3
        : 0.4 + _rnd.nextDouble() * 0.7;

    return Bubble(
      position: Offset(
        areBubblesDisabled
            ? width * 0.3 + _rnd.nextDouble() * (width * 0.4)
            : _rnd.nextBool()
                ? _rnd.nextDouble() * side
                : width - _rnd.nextDouble() * side,
        y ??
            (areBubblesDisabled
                ? height + 20 + _rnd.nextDouble() * 50
                : height * 0.5 + _rnd.nextDouble() * height * 0.5),
      ),
      radius: bubbleSize,
      speed: bubbleSpeed,
      color: colors[_rnd.nextInt(colors.length)],
    );
  }

  void _tick() {
    if (!mounted) return;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    setState(() {
      for (final b in _bubbles) {
        if (b.popping) {
          b.popProgress += 0.04 * _tiltFactor;
          if (b.popProgress >= 1) {
            final idx = _bubbles.indexOf(b);
            _bubbles[idx] = _randomBubble(
              y: height + 40,
              width: width,
              height: height,
            );
          }
        } else {
          if (areBubblesDisabled) {
            double horizontalSway = sin(
                    DateTime.now().millisecondsSinceEpoch / 1000.0 +
                        b.position.dx) *
                0.5;
            b.position = b.position.translate(horizontalSway, -b.speed * 0.3);
          } else {
            b.position = b.position.translate(0, -b.speed * _tiltFactor);
          }

          if (b.position.dy + b.radius < -40) {
            final idx = _bubbles.indexOf(b);
            _bubbles[idx] = _randomBubble(
              y: areBubblesDisabled
                  ? height + 20 + _rnd.nextDouble() * 50
                  : height + 40,
              width: width,
              height: height,
            );
          }
        }
      }
    });
  }

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
    _accelerometerSubscription.cancel();
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

    return ShakeGesture(
      onShake: () {
        setState(() {
          areBubblesDisabled = !areBubblesDisabled;
        });
      },
      child: areBubblesDisabled ? _buildEmptyBackground() : _buildBubbles(),
    );
  }

  Widget _buildEmptyBackground() {
    final bg = Theme.of(context).colorScheme.background;
    return Container(
      color: bg,
      child: widget.child,
    );
  }

  Widget _buildBubbles() {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final baseAlpha = isLight ? 0.001 : 0.01;
    final borderColor = Colors.lightBlueAccent.withValues(alpha: baseAlpha);
    final bg = Theme.of(context).colorScheme.background;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
      child: CustomPaint(
        painter: _BubblesPainter(
          _bubbles,
          borderColor: borderColor,
          backgroundColor: bg,
        ),
        child: widget.child,
      ),
    );
  }
}

class _BubblesPainter extends CustomPainter {
  final List<Bubble> bubbles;
  final Color borderColor;
  final Color backgroundColor;

  _BubblesPainter(
    this.bubbles, {
    this.borderColor = const Color(0xFFFFFFFF),
    this.backgroundColor = const Color(0xFFFFFFFF),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, bgPaint);
    for (final b in bubbles) {
      final paint = Paint()
        ..color = b.color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      final borderPaint = Paint()
        ..color = borderColor.withOpacity(0.7)
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
