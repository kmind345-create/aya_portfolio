import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A headline that continuously catches the light: a soft lilac sweep
/// glides left-to-right across a cream base, then loops. Pure
/// AnimationController + ShaderMask, cheap to run forever.
class ShimmerHeadline extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const ShimmerHeadline({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.left,
  });

  @override
  State<ShimmerHeadline> createState() => _ShimmerHeadlineState();
}

class _ShimmerHeadlineState extends State<ShimmerHeadline>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
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
      builder: (context, _) {
        final t = _controller.value; // 0..1
        // Sweep slides from -1.5 to 1.5 across the text bounds.
        final sweepCenter = -1.5 + t * 3.0;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                AppColors.cream,
                AppColors.cream,
                AppColors.orchidSoft,
                AppColors.cream,
                AppColors.cream,
              ],
              stops: [
                0.0,
                (sweepCenter - 0.35).clamp(0.0, 1.0),
                sweepCenter.clamp(0.0, 1.0),
                (sweepCenter + 0.35).clamp(0.0, 1.0),
                1.0,
              ],
            ).createShader(rect);
          },
          child: Text(widget.text, textAlign: widget.textAlign, style: widget.style),
        );
      },
    );
  }
}
