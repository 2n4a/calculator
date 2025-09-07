import 'package:calculator/features/calculator/domain/entities/calculation.dart';
import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final List<Calculation> history;
  final ScrollController? scrollController;

  const HistoryList({super.key, required this.history, this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(child: Text('История пуста'));
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final colorScheme = Theme.of(context).colorScheme;
        return Card(
          color: colorScheme.surface,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              item.expression,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
            ),
            subtitle: Text(
              '= ${item.result}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.85),
                  ),
            ),
            trailing: item.timestamp != null
                ? Text(
                    '${item.timestamp}',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 12,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
