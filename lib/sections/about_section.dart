import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_heading.dart';
import '../widgets/tilt_3d_card.dart';

class AboutSection extends StatelessWidget {
  final bool isMobile;
  const AboutSection({super.key, required this.isMobile});

  static const _skills = [
    'Character Illustration',
    'Logo & Wordmarks',
    'Brand Identity',
    'Packaging Art',
    'Editorial Illustration',
    'Vector Portraits',
  ];

  @override
  Widget build(BuildContext context) {
    final bio = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          eyebrow: 'ABOUT AYA',
          title: 'A designer who\nbelieves in restraint.',
        ),
        const SizedBox(height: 26),
        Text(
          "I'm Aya — an illustrator and logo designer who treats every "
          "brief as a chance to strip an idea down to its clearest, most "
          "memorable shape. My work blends warm, hand-felt illustration "
          "with the precision of clean vector logo systems, so brands end "
          "up with art that feels personal and a mark that scales from a "
          "favicon to a storefront.",
          style: AppFonts.body(size: 16.5),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _skills
              .map((s) => _SkillChip(label: s))
              .toList(growable: false),
        ),
      ],
    );

    final statsCard = Tilt3DCard(
      maxTiltDegrees: 6,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(gradient: AppColors.cardGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            _StatRow(value: 60, suffix: '+', label: 'Brands illustrated & branded'),
            SizedBox(height: 22),
            _StatRow(value: 6, suffix: ' yrs', label: 'Designing logos & visual identities'),
            SizedBox(height: 22),
            _StatRow(value: 100, suffix: '%', label: 'Custom, never templated'),
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 110,
      ),
      child: isMobile
          ? Column(
              children: [
                RevealOnScroll(child: bio),
                const SizedBox(height: 40),
                RevealOnScroll(delay: const Duration(milliseconds: 150), child: statsCard),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: RevealOnScroll(child: bio)),
                const SizedBox(width: 60),
                Expanded(
                  flex: 4,
                  child: RevealOnScroll(
                    delay: const Duration(milliseconds: 150),
                    child: statsCard,
                  ),
                ),
              ],
            ),
    );
  }
}

class _SkillChip extends StatefulWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: _hover ? AppColors.violetPop.withOpacity(0.18) : AppColors.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: _hover ? AppColors.violetPop : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Text(
          widget.label,
          style: AppFonts.body(
            size: 13.5,
            weight: FontWeight.w600,
            color: _hover ? AppColors.cream : AppColors.creamDim,
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final int value;
  final String suffix;
  final String label;
  const _StatRow({required this.value, required this.suffix, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (rect) => AppColors.violetGradient.createShader(rect),
          child: TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: value),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) => Text(
              '$v$suffix',
              style: AppFonts.display(size: 30, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(label, style: AppFonts.body(size: 14.5)),
        ),
      ],
    );
  }
}
