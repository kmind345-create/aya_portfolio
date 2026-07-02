import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class SectionHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final TextAlign align;

  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxis = align == TextAlign.center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: crossAxis,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 2,
              color: AppColors.orchid,
            ),
            const SizedBox(width: 10),
            Text(eyebrow, style: AppFonts.label()),
          ],
        ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1, end: 0),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: align,
          style: AppFonts.display(size: 40, height: 1.08),
        ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideY(
              begin: 0.15,
              end: 0,
              curve: Curves.easeOutCubic,
            ),
        if (subtitle != null) ...[
          const SizedBox(height: 14),
          SizedBox(
            width: 560,
            child: Text(
              subtitle!,
              textAlign: align,
              style: AppFonts.body(size: 16.5),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
        ],
      ],
    );
  }
}
