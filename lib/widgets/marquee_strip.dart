import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// An infinitely-scrolling horizontal strip of words, separated by a small
/// diamond glyph. Purely decorative motion used as a section divider — the
/// kind of continuous marquee a print-inspired brand site leans on.
class MarqueeStrip extends StatefulWidget {
  final List<String> words;
  final double height;

  const MarqueeStrip({
    super.key,
    required this.words,
    this.height = 64,
  });

  @override
  State<MarqueeStrip> createState() => _MarqueeStripState();
}

class _MarqueeStripState extends State<MarqueeStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.words.length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.words[i],
                style: AppFonts.display(
                  size: 26,
                  weight: FontWeight.w600,
                  color: AppColors.creamDim,
                ),
              ),
              const SizedBox(width: 22),
              const Icon(Icons.diamond, size: 10, color: AppColors.violetPop),
            ],
          ),
        );
      }),
    );

    return Container(
      height: widget.height,
      color: AppColors.surface.withOpacity(0.5),
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return OverflowBox(
              maxWidth: double.infinity,
              alignment: Alignment.centerLeft,
              child: FractionalTranslation(
                translation: Offset(-_controller.value * 0.5, 0),
                child: Row(mainAxisSize: MainAxisSize.min, children: [row, row]),
              ),
            );
          },
        ),
      ),
    );
  }
}
