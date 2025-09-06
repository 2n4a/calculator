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
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              item.expression,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('= ${item.result}'),
            trailing:
                item.timestamp != null
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
