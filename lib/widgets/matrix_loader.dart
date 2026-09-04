import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Paridad con front_nuxt `TheCustomLoader`: grilla de unos y ceros
/// parpadeando en tonos crocus + frase rotando.
class MatrixLoader extends StatefulWidget {
  final List<String> phrases;
  const MatrixLoader({
    super.key,
    this.phrases = const [
      'Precalentando la cocina…',
      'Revisando los pedidos…',
      'Hablando con el servidor…',
      'Casi listo…',
    ],
  });

  @override
  State<MatrixLoader> createState() => _MatrixLoaderState();
}

class _MatrixLoaderState extends State<MatrixLoader> with SingleTickerProviderStateMixin {
  static const _bits = [1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1];
  late final List<double> _delays;
  late final AnimationController _ctrl;
  int _phrase = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final rand = Random();
    _delays = [for (final _ in _bits) rand.nextDouble() * 2];
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (mounted) setState(() => _phrase = (_phrase + 1) % widget.phrases.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
              itemCount: _bits.length,
              itemBuilder: (_, i) => AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) {
                  final t = ((_ctrl.value * 2 + _delays[i]) % 1.2) / 1.2;
                  final on = t < 0.5;
                  return Center(
                    child: Text(
                      '${_bits[i]}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 16,
                        color: on
                            ? (_bits[i] == 1 ? AppColors.crocus600 : AppColors.crocus300)
                            : AppColors.crocus600.withValues(alpha: 0.2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              widget.phrases[_phrase],
              key: ValueKey(_phrase),
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.crocus600),
            ),
          ),
        ],
      ),
    );
  }
}
