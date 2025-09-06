import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassContainer extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double blur;
  final bool animate;

  const LiquidGlassContainer({
    Key? key,
    required this.child,
    this.borderRadius = 32.0,
    this.backgroundColor,
    this.borderColor,
    this.blur = 35.0,
    this.animate = true,
  }) : super(key: key);

  @override
  State<LiquidGlassContainer> createState() => _LiquidGlassContainerState();
}

class _LiquidGlassContainerState extends State<LiquidGlassContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
            child: CustomPaint(
              painter:
                  widget.animate
                      ? _LiquidBorderPainter(
                        animation: _controller,
                        borderRadius: widget.borderRadius,
                        borderColor:
                            widget.borderColor ??
                            Colors.white.withValues(alpha: 0.25),
                      )
                      : null,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      widget.backgroundColor ??
                      Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    color:
                        widget.borderColor ??
                        Colors.white.withValues(alpha: 0.15),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LiquidBorderPainter extends CustomPainter {
  final Animation<double> animation;
  final double borderRadius;
  final Color borderColor;

  _LiquidBorderPainter({
    required this.animation,
    required this.borderRadius,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paintShadow =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withValues(
                alpha: math.max(
                  0.0,
                  0.2 + 0.1 * math.sin(animation.value * math.pi * 2),
                ),
              ),
              Colors.purple.withValues(
                alpha: math.max(
                  0.0,
                  0.2 + 0.1 * math.cos(animation.value * math.pi * 2),
                ),
              ),
              Colors.cyan.withValues(
                alpha: math.max(
                  0.0,
                  0.2 + 0.1 * math.sin(animation.value * math.pi),
                ),
              ),
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(rect);

    final path =
        Path()..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
        );

    // Создание эффекта "жидкости" вдоль границы
    final wavyPath = Path();
    const waveCount = 15; // количество волн
    const waveHeight = 1.5; // высота волны
    final double pathLength = path.computeMetrics().first.length;
    final double increment = pathLength / waveCount;

    for (var i = 0.0; i < pathLength; i += increment / 10) {
      final metric = path.computeMetrics().first;
      final tangent = metric.getTangentForOffset(i);

      if (tangent != null) {
        final pos = tangent.position;
        final normal =
            Offset(-tangent.vector.dy, tangent.vector.dx).normalized();
        final waveOffset =
            normal *
            waveHeight *
            math.sin(
              (i / increment * math.pi * 2) + animation.value * math.pi * 6,
            );

        if (i == 0) {
          wavyPath.moveTo(pos.dx + waveOffset.dx, pos.dy + waveOffset.dy);
        } else {
          wavyPath.lineTo(pos.dx + waveOffset.dx, pos.dy + waveOffset.dy);
        }
      }
    }

    wavyPath.close();

    canvas.drawPath(
      wavyPath,
      paintShadow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Внутреннее свечение
    final innerGlowPaint =
        Paint()
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withValues(
                alpha: 0.15 * math.sin(animation.value * math.pi * 2).abs(),
              ),
              Colors.purple.withValues(
                alpha: 0.15 * math.cos(animation.value * math.pi * 2).abs(),
              ),
            ],
          ).createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(borderRadius / 2),
        Radius.circular(borderRadius / 2),
      ),
      innerGlowPaint,
    );
  }

  @override
  bool shouldRepaint(_LiquidBorderPainter oldDelegate) => true;
}

// Расширение для нормализации векторов
extension NormalizedOffset on Offset {
  Offset normalized() {
    final length = distance;
    if (length == 0.0) return Offset.zero;
    return Offset(dx / length, dy / length);
  }
}
