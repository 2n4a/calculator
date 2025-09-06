import 'dart:ui';
import 'package:calculator/core/app_icons.dart';
import 'package:calculator/features/calculator/domain/entities/calculation.dart';
import 'package:calculator/features/calculator/presentation/widgets/animated_history_list.dart';
import 'package:calculator/features/calculator/presentation/widgets/liquid_glass_container.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AnimatedHistoryModal extends StatefulWidget {
  final List<Calculation> history;
  final Function() onClose;
  final Function()? onRefresh;
  final dynamic calculatorController;
  final bool showWaterBubbles;

  const AnimatedHistoryModal({
    Key? key,
    required this.history,
    required this.onClose,
    this.onRefresh,
    this.calculatorController,
    this.showWaterBubbles = true,
  }) : super(key: key);

  @override
  State<AnimatedHistoryModal> createState() => _AnimatedHistoryModalState();
}

class _AnimatedHistoryModalState extends State<AnimatedHistoryModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late List<Calculation> _localHistory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print('🏗️ AnimatedHistoryModal.initState() - модальное окно создано');
    _localHistory = List.from(widget.history);
    print(
      '📜 Локальная история инициализирована: ${_localHistory.length} элементов',
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<double>(
      begin: 200,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    print('🗑️ AnimatedHistoryModal.dispose() - модальное окно уничтожено');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 40 * _opacityAnimation.value,
            sigmaY: 40 * _opacityAnimation.value,
          ),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    if (widget.showWaterBubbles) _buildWaterBubbles(),

                    // Контент истории
                    _buildHistoryContent(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LiquidGlassContainer(
        borderRadius: 32,
        backgroundColor: Colors.black.withValues(alpha: 0.15),
        blur: 30.0,
        child: Column(
          children: [
            _buildHeader(),
            _buildDivider(),
            Expanded(
              child:
                  _isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white70,
                          strokeWidth: 3,
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: _refreshHistory,
                        color: Colors.blue,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                          child: AnimatedHistoryList(history: _localHistory),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshHistory() async {
    print('🔄 _refreshHistory() вызван');
    if (widget.onRefresh != null) {
      setState(() {
        _isLoading = true;
      });
      print('⏳ Начинаем обновление истории...');

      try {
        await Future.delayed(const Duration(milliseconds: 300));
        await widget.onRefresh!();
        print('✅ История обновлена');

        if (mounted) {
          setState(() {
            _localHistory = List.from(
              widget.calculatorController?.history ?? widget.history,
            );
            _isLoading = false;
          });
          print(
            '📜 Локальная история обновлена: ${_localHistory.length} элементов',
          );
        }
      } catch (e) {
        print('❌ Ошибка при обновлении истории: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                AppIcons.history,
                color: Colors.white.withValues(alpha: 0.9),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'История',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.blue,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  MdiIcons.refresh,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                tooltip: 'Обновить историю',
                onPressed: _refreshHistory,
              ),
              IconButton(
                icon: Icon(
                  AppIcons.close,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                onPressed: _closeWithAnimation,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.blue.withValues(alpha: 0.7),
            Colors.purple.withValues(alpha: 0.7),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildWaterBubbles() {
    return Positioned.fill(
      child: IgnorePointer(child: CustomPaint(painter: _BubblesPainter())),
    );
  }

  void _closeWithAnimation() async {
    await _controller.reverse();
    widget.onClose();
  }
}

class _BubblesPainter extends CustomPainter {
  final List<_Bubble> bubbles = List.generate(25, (_) => _Bubble.random());

  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in bubbles) {
      bubble.update();
      bubble.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(_BubblesPainter oldDelegate) => true;
}

class _Bubble {
  late double x;
  late double y;
  late double size;
  late double speed;
  late double opacity;
  late Color color;

  _Bubble.random() {
    final random = DateTime.now().microsecondsSinceEpoch % 10000 / 10000;
    x = random * 1.2 - 0.1;
    y = 1.0 + random * 0.3;
    size = 0.03 + random * 0.06;
    speed = 0.001 + random * 0.002;
    opacity = 0.3 + random * 0.4;

    final hue = 200.0 + random * 60;
    color = HSLColor.fromAHSL(opacity, hue, 0.7, 0.6).toColor();
  }

  void update() {
    y -= speed;

    if (y < -size) {
      y = 1.0;
      x = (DateTime.now().microsecondsSinceEpoch % 10000 / 10000) * 1.2 - 0.1;
    }
  }

  void draw(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawCircle(
      Offset(x * size.width, y * size.height),
      this.size * size.width * 0.3,
      paint,
    );
  }
}
