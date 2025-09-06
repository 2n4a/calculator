import 'dart:math';
import 'package:calculator/features/calculator/domain/entities/calculation.dart';
import 'package:flutter/material.dart';
import 'liquid_glass_container.dart';

class AnimatedHistoryList extends StatelessWidget {
  final List<Calculation> history;
  final ScrollController? scrollController;

  const AnimatedHistoryList({
    Key? key,
    required this.history,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(
        child: Text(
          'История пуста',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final random = Random(index);

        return AnimatedHistoryItem(index: index, item: item, random: random);
      },
    );
  }
}

class AnimatedHistoryItem extends StatefulWidget {
  final int index;
  final Calculation item;
  final Random random;

  const AnimatedHistoryItem({
    Key? key,
    required this.index,
    required this.item,
    required this.random,
  }) : super(key: key);

  @override
  State<AnimatedHistoryItem> createState() => _AnimatedHistoryItemState();
}

class _AnimatedHistoryItemState extends State<AnimatedHistoryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;
  late Animation<double> _slideOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuint,
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(curve);
    _slideOffset = Tween<double>(begin: 50, end: 0).animate(curve);

    Future.delayed(Duration(milliseconds: 70 * widget.index), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hueOffset = widget.random.nextDouble() * 0.2;
    final primaryColor =
        HSLColor.fromAHSL(
          0.8,
          220 + 20 * hueOffset,
          0.7 + 0.2 * widget.random.nextDouble(),
          0.5 + 0.2 * widget.random.nextDouble(),
        ).toColor();

    final secondaryColor =
        HSLColor.fromAHSL(
          0.7,
          190 + 30 * hueOffset,
          0.6 + 0.3 * widget.random.nextDouble(),
          0.6 + 0.2 * widget.random.nextDouble(),
        ).toColor();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _slideOffset.value),
            child: Transform.scale(
              scale: _scale.value,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: LiquidGlassContainer(
                  borderRadius: 18.0 + widget.random.nextDouble() * 2,
                  backgroundColor: Colors.white.withValues(
                    alpha: 0.08 + 0.06 * widget.random.nextDouble(),
                  ),
                  borderColor:
                      widget.random.nextBool()
                          ? primaryColor.withValues(alpha: 0.2)
                          : secondaryColor.withValues(alpha: 0.2),
                  blur: 16.0 + widget.random.nextDouble() * 4,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Скопировано: ${widget.item.expression} = ${widget.item.result}",
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.expression,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withValues(alpha: 0.95),
                              shadows: [
                                Shadow(
                                  color: primaryColor.withValues(alpha: 0.7),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 6),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "=  ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryColor.withValues(alpha: 0.7),
                                          secondaryColor.withValues(alpha: 0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      widget.item.result,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              if (widget.item.timestamp != null)
                                Text(
                                  widget.item.timestamp!.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
