import 'dart:math';
import 'package:calculator/features/calculator/domain/entities/calculation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class _AnimatedHistoryItemState extends State<AnimatedHistoryItem> {
  late final double _borderRadius;
  late final double _backgroundOpacity;
  late final bool _usePrimaryBorder;
  late final Color _primaryColor;
  late final Color _secondaryColor;
  late final String? _formattedTimestamp;

  @override
  void initState() {
    super.initState();
    final r = widget.random;
    final hueOffset = r.nextDouble() * 0.2;
    _primaryColor = HSLColor.fromAHSL(
      0.8,
      220 + 20 * hueOffset,
      0.7 + 0.2 * r.nextDouble(),
      0.5 + 0.2 * r.nextDouble(),
    ).toColor();
    _secondaryColor = HSLColor.fromAHSL(
      0.7,
      190 + 30 * hueOffset,
      0.6 + 0.3 * r.nextDouble(),
      0.6 + 0.2 * r.nextDouble(),
    ).toColor();
    _borderRadius = 18.0 + r.nextDouble() * 2;
    _backgroundOpacity = 0.08 + 0.06 * r.nextDouble();
    _usePrimaryBorder = r.nextBool();
    _formattedTimestamp = widget.item.timestamp == null
        ? null
        : widget.item.timestamp!
            .toLocal()
            .toString()
            .split('.')
            .first;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_borderRadius),
            onTap: () async {
              final textToCopy = "${widget.item.expression} = ${widget.item.result}";
              await Clipboard.setData(ClipboardData(text: textToCopy));
              if (!context.mounted) return;
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
                  backgroundColor: colorScheme.secondaryContainer.withOpacity(0.7),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  duration: const Duration(milliseconds: 1500),
                ),
              );
            },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
              color: colorScheme.surface.withOpacity(_backgroundOpacity),
              border: Border.all(
                color: (_usePrimaryBorder ? colorScheme.primary : colorScheme.secondary).withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.expression,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface.withOpacity(0.95),
                        shadows: [
                          Shadow(
                            color: _primaryColor.withOpacity(0.55),
                            blurRadius: 3.0,
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface.withOpacity(0.7),
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
                                _primaryColor.withValues(alpha: 0.7),
                                _secondaryColor.withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Builder(builder: (context) {
                            final full = widget.item.result;
                            final display = full.length > 10
                                ? full.substring(0, 10)
                                : full;
                            return Tooltip(
                              message: full.length > 10 ? full : '',
                              waitDuration: const Duration(milliseconds: 300),
                              child: Text(
                                display,
                                overflow: TextOverflow.visible,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onPrimary,
                                    ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    if (_formattedTimestamp != null)
                      Text(
                        _formattedTimestamp,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
