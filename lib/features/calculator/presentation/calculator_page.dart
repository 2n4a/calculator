import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:calculator/core/app_icons.dart';
import 'calculator_controller.dart';
import 'widgets/history_list.dart';
import 'widgets/animated_bubbles_background.dart';

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

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
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
  const FrostedGlass({super.key, required this.child, this.borderRadius = 28, this.blur = 18, this.color});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: (color ?? Colors.white.withOpacity(0.18)),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.08),
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
  bool _showHistory = false;

  void _openHistory() {
    setState(() => _showHistory = true);
    widget.controller.fetchHistory();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (_, controller) => FrostedGlass(
          borderRadius: 32,
          blur: 24,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('История', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    IconButton(
                      icon: Icon(AppIcons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(child: HistoryList(history: widget.controller.history, scrollController: controller)),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(() => setState(() => _showHistory = false));
  }



  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final isWide = MediaQuery.of(context).size.width > 700;
    return AnimatedBubblesBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Row(
            children: [
              Icon(AppIcons.calculate, size: 30),
              SizedBox(width: 10),
              const Text('Калькулятор', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(AppIcons.history),
              tooltip: 'История',
              onPressed: _openHistory,
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        style: const TextStyle(fontSize: 22),
                        decoration: InputDecoration(
                          prefixIcon: Icon(AppIcons.edit),
                          labelText: 'Введите выражение',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.18),
                        ),
                        onChanged: controller.setExpression,
                        onSubmitted: (_) => controller.calculate(),
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        controller: TextEditingController(text: controller.expression),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          icon: Icon(AppIcons.play, size: 28),
                          label: controller.loading
                              ? const SizedBox(
                                  width: 28, height: 28,
                                  child: CircularProgressIndicator(strokeWidth: 3),
                                )
                              : const Text('Вычислить'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 6,
                            backgroundColor: Colors.blue.shade700.withOpacity(0.85),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            shadowColor: Colors.blueAccent.withOpacity(0.3),
                          ),
                          onPressed: controller.loading ? null : controller.calculate,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: FadeTransition(opacity: anim, child: child)),
                        child: controller.result.isNotEmpty
                            ? Column(
                                key: ValueKey(controller.result),
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        AppIcons.result,
                                        color: Colors.cyanAccent.shade400,
                                        size: 32,
                                        shadows: [Shadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 8)],
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Результат:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SelectableText(
                                    controller.result,
                                    style: TextStyle(fontSize: 32, color: Colors.blue.shade900, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.cyanAccent.withOpacity(0.2), blurRadius: 8)]),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 32),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _showHistory ? 0.3 : 1,
                        child: Text(
                          'Введите выражение и нажмите "Вычислить"\nили Enter',
                          style: TextStyle(color: Colors.white.withOpacity(0.8)),
                          textAlign: TextAlign.center,
                        ),
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
  }
}
