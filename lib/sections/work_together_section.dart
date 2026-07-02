import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_heading.dart';
import '../widgets/tilt_3d_card.dart';

class WorkTogetherOption {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final List<String> highlights;
  final bool featured;
  const WorkTogetherOption({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.highlights,
    this.featured = false,
  });
}

const _options = [
  WorkTogetherOption(
    number: '01',
    title: 'A Single Project',
    description: 'One clear deliverable, done end-to-end — a logo, a '
        'packaging illustration, a set of editorial pieces.',
    icon: Icons.crop_free_rounded,
    highlights: [
      'Fixed scope & flat price',
      'Concept to final files',
      'Great for a one-off need',
    ],
  ),
  WorkTogetherOption(
    number: '02',
    title: 'A Full Brand Package',
    description: 'Logo, visual identity, and packaging or illustration '
        'system built together so every touchpoint matches.',
    icon: Icons.auto_awesome_rounded,
    highlights: [
      'Logo + identity system',
      'Illustration & packaging art',
      'One consistent visual voice',
    ],
    featured: true,
  ),
  WorkTogetherOption(
    number: '03',
    title: 'An Ongoing Retainer',
    description: 'Monthly design support for brands that need new '
        'illustration, assets, or refinements on a regular basis.',
    icon: Icons.autorenew_rounded,
    highlights: [
      'Priority monthly hours',
      'Consistent point of contact',
      'Scale up or pause anytime',
    ],
  ),
];

class WorkTogetherSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final VoidCallback? onContact;
  const WorkTogetherSection({
    super.key,
    required this.isMobile,
    required this.isTablet,
    this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final columns = isMobile ? 1 : (isTablet ? 2 : 3);

    return Container(
      width: double.infinity,
      color: AppColors.surface.withOpacity(0.4),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 110,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(
            child: const SectionHeading(
              eyebrow: 'LET\'S COLLABORATE',
              title: 'Pick a way\nto start.',
              subtitle: 'However much (or little) you need, there\'s a '
                  'straightforward way to get started.',
            ),
          ),
          const SizedBox(height: 48),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _options.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 26,
              mainAxisSpacing: 26,
              childAspectRatio: isMobile ? 0.95 : 1.05,
            ),
            itemBuilder: (context, i) {
              final o = _options[i];
              return RevealOnScroll(
                delay: Duration(milliseconds: 100 * i),
                child: Tilt3DCard(
                  maxTiltDegrees: 8,
                  borderRadius: BorderRadius.circular(26),
                  child: _OptionCard(option: o, onContact: onContact),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final WorkTogetherOption option;
  final VoidCallback? onContact;
  const _OptionCard({required this.option, this.onContact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: option.featured ? AppColors.violetGradientWide : AppColors.cardGradient,
        border: option.featured
            ? Border.all(color: AppColors.orchid.withOpacity(0.6), width: 1.4)
            : Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Stack(
        children: [
          // Decorative oversized icon ghosted in the background — only on
          // the plain cards, since the featured card already has a full
          // gradient fill and doesn't need it.
          if (!option.featured)
            Positioned(
              right: -18,
              bottom: -18,
              child: Icon(
                option.icon,
                size: 150,
                color: Colors.white.withOpacity(0.045),
              ),
            ),
          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: option.featured
                      ? const LinearGradient(colors: [AppColors.cream, AppColors.orchidSoft])
                      : AppColors.violetGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(option.icon, color: AppColors.bgDeep, size: 24),
              ),
              Text(option.number,
                  style: AppFonts.label(
                    size: 13,
                    color: option.featured ? Colors.white.withOpacity(0.75) : AppColors.creamDim,
                  )),
            ],
          ),
          const SizedBox(height: 22),
          if (option.featured)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'MOST POPULAR',
                style: AppFonts.label(size: 10, color: Colors.white, letterSpacing: 1.4),
              ),
            ),
          Text(
            option.title,
            style: AppFonts.display(size: 21, weight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(option.description, style: AppFonts.body(size: 14, height: 1.55)),
          const SizedBox(height: 18),
          ...option.highlights.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_rounded,
                      size: 16,
                      color: option.featured ? Colors.white : AppColors.orchid),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      h,
                      style: AppFonts.body(
                        size: 13.5,
                        color: option.featured ? Colors.white.withOpacity(0.9) : AppColors.creamDim,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(height: 8),
          _CtaLink(featured: option.featured, onTap: onContact),
        ],
          ),
        ],
      ),
    );
  }
}

class _CtaLink extends StatefulWidget {
  final bool featured;
  final VoidCallback? onTap;
  const _CtaLink({required this.featured, this.onTap});

  @override
  State<_CtaLink> createState() => _CtaLinkState();
}

class _CtaLinkState extends State<_CtaLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.featured ? Colors.white : AppColors.orchid;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 180),
          offset: _hover ? const Offset(0.05, 0) : Offset.zero,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Let\'s talk',
                style: AppFonts.label(size: 12.5, color: color, letterSpacing: 0.8),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_outward_rounded, size: 15, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
