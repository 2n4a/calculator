import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:calculator/core/app_icons.dart';
import 'calculator_controller.dart';
import 'widgets/animated_bubbles_background.dart';
import 'widgets/animated_history_modal.dart';

class CalculatorPage extends StatefulWidget {
  final CalculatorController controller;

  const CalculatorPage({Key? key, required this.controller}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
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
        final t = _controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(Colors.deepPurple, Colors.blue, sin(t * pi))!,
                Color.lerp(Colors.purple, Colors.cyan, cos(t * pi))!,
                Color.lerp(Colors.indigo, Colors.teal, t)!,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class FrostedGlass extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color? color;

  const FrostedGlass({
    super.key,
    required this.child,
    this.borderRadius = 28,
    this.blur = 18,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: (color ?? Colors.white.withValues(alpha: 0.18)),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _CalculatorPageState extends State<CalculatorPage> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    print('🏗️ _CalculatorPageState.initState() - виджет создан');
    _textController = TextEditingController(text: widget.controller.expression);

    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (_textController.text != widget.controller.expression) {
      final selection = _textController.selection;
      _textController.text = widget.controller.expression;
      _textController.selection = selection;
    }
  }

  @override
  void dispose() {
    print('🗑️ _CalculatorPageState.dispose() - виджет уничтожен');
    widget.controller.removeListener(_onControllerChanged);
    _textController.dispose();
    super.dispose();
  }

  Future<void> _openHistory() async {
    print('📜 _openHistory() вызван');
    await widget.controller.fetchHistory();
    print('📜 История получена, открываем диалог');

    if (!mounted) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "История вычислений",
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: DraggableScrollableSheet(
              initialChildSize: 1.0,
              minChildSize: 0.9,
              maxChildSize: 1.0,
              builder: (context, controller) {
                return GestureDetector(
                  onTap: () {},
                  child: AnimatedHistoryModal(
                    history: widget.controller.history,
                    onClose: () => Navigator.of(context).pop(),
                    onRefresh: () => widget.controller.fetchHistory(),
                    calculatorController: widget.controller,
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
      '🔄 _CalculatorPageState.build() вызван - ПОЛНАЯ ПЕРЕСТРОЙКА СТРАНИЦЫ',
    );
    final isWide = MediaQuery.of(context).size.width > 700;
    return AnimatedBubblesBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Row(
            children: [
              Icon(AppIcons.calculate, size: 30),
              SizedBox(width: 10),
              const Text(
                'Калькулятор',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(AppIcons.history),
              tooltip: 'История',
              onPressed: () {
                print('🖱️ Кнопка истории нажата');
                _openHistory();
              },
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isWide ? 480 : double.infinity,
                minWidth: isWide ? 420 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: FrostedGlass(
                borderRadius: 32,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ListenableBuilder(
                      listenable: widget.controller,
                      builder: (context, child) {
                        print('🔄 TextField ListenableBuilder перестроен');
                        return TextField(
                          controller: _textController,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 22),
                          maxLines: null,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            prefixIcon: Icon(AppIcons.edit,
                                color: Theme.of(context).iconTheme.color),
                            labelText: 'Введите выражение',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(0.18),
                            alignLabelWithHint: true,
                          ),
                          onChanged: (value) {
                            widget.controller.setExpression(value);
                          },
                          onSubmitted: (_) => widget.controller.calculate(),
                          autofocus: false,
                          textInputAction: TextInputAction.done,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    ListenableBuilder(
                      listenable: widget.controller,
                      builder: (context, child) {
                        print(
                          '🔄 Button ListenableBuilder перестроен - loading: ${widget.controller.loading}',
                        );
                        return SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            icon: Icon(AppIcons.play, size: 28),
                            label: widget.controller.loading
                                ? const SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text('Вычислить'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 6,
                              backgroundColor:
                                  Colors.blue.shade700.withOpacity(0.85),
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              shadowColor: Colors.blueAccent.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            onPressed: widget.controller.loading
                                ? null
                                : widget.controller.calculate,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ListenableBuilder(
                      listenable: widget.controller,
                      builder: (context, child) {
                        print(
                          '🔄 Result ListenableBuilder перестроен - result: "${widget.controller.result}"',
                        );
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, anim) => ScaleTransition(
                            scale: anim,
                            child: FadeTransition(
                              opacity: anim,
                              child: child,
                            ),
                          ),
                          child: widget.controller.result.isNotEmpty
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    key: ValueKey(widget.controller.result),
                                    children: [
                                      SelectableText(
                                        widget.controller.result,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge
                                            ?.copyWith(
                                          fontSize: double.tryParse(widget
                                                      .controller.result) !=
                                                  null
                                              ? 32
                                              : 20,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          shadows: [
                                            Shadow(
                                              color: Colors.cyanAccent
                                                  .withOpacity(0.2),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Введите выражение и нажмите "Вычислить"\nили Enter',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Theme.of(context).hintColor),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
