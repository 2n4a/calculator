import 'dart:math';
import 'package:calculator/features/calculator/domain/entities/calculation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      final txtStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).hintColor,
          );
      return Center(
        child: Text(
          'История пуста',
          style: txtStyle,
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
      duration: const Duration(milliseconds: 200),
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuint,
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    _scale = Tween<double>(begin: 0.9, end: 1.0).animate(curve);
    _slideOffset = Tween<double>(begin: 30, end: 0).animate(curve);

    Future.delayed(Duration(milliseconds: 30 * widget.index), () {
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
    final primaryColor = HSLColor.fromAHSL(
      0.8,
      220 + 20 * hueOffset,
      0.7 + 0.2 * widget.random.nextDouble(),
      0.5 + 0.2 * widget.random.nextDouble(),
    ).toColor();

    final secondaryColor = HSLColor.fromAHSL(
      0.7,
      190 + 30 * hueOffset,
      0.6 + 0.3 * widget.random.nextDouble(),
      0.6 + 0.2 * widget.random.nextDouble(),
    ).toColor();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final colorScheme = Theme.of(context).colorScheme;
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
                  backgroundColor: colorScheme.surface.withOpacity(
                    0.08 + 0.06 * widget.random.nextDouble(),
                  ),
                  borderColor: widget.random.nextBool()
                      ? colorScheme.primary.withOpacity(0.2)
                      : colorScheme.secondary.withOpacity(0.2),
                  blur: 16.0 + widget.random.nextDouble() * 4,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () async {
                      final textToCopy =
                          "${widget.item.expression} = ${widget.item.result}";
                      await Clipboard.setData(ClipboardData(text: textToCopy));

                      if (context.mounted) {
                        final scaffold = ScaffoldMessenger.of(context);
                        scaffold.clearSnackBars();
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(
                              "Скопировано: $textToCopy",
                              style: TextStyle(
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                            backgroundColor:
                                colorScheme.secondaryContainer.withOpacity(0.7),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            duration: const Duration(milliseconds: 1500),
                          ),
                        );
                      }

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
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18,

                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface.withOpacity(0.95),
                              shadows: [
                                Shadow(
                                  color: primaryColor.withOpacity(0.7),
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
                                  Text(
                                    "=  ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 17,

                                          fontWeight: FontWeight.w500,
                                          color: colorScheme.onSurface
                                              .withOpacity(0.7),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 17,

                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onPrimary,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              if (widget.item.timestamp != null)
                                Text(
                                  widget.item.timestamp!
                                      .toLocal()
                                      .toString()
                                      .split('.')[0],

                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,

                                        color: colorScheme.onSurface
                                            .withOpacity(0.6),
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
