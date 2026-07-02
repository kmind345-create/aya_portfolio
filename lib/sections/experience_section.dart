import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_heading.dart';

class ExperienceItem {
  final String period;
  final String role;
  final String place;
  final String description;
  final bool current;
  const ExperienceItem({
    required this.period,
    required this.role,
    required this.place,
    required this.description,
    this.current = false,
  });
}

/// NOTE: Placeholder timeline — swap in Aya's real roles, studio names, and
/// dates. Ordered most-recent first; the `current` flag lights up the dot
/// and adds the "Present" badge.
const List<ExperienceItem> kExperienceItems = [
  ExperienceItem(
    period: '2023 — Present',
    role: 'Freelance Illustrator & Logo Designer',
    place: "Aya's Graphique",
    description: 'Independent studio taking on brand identity, packaging '
        'illustration, and editorial work for clients across the region — '
        'from first sketch to production-ready files.',
    current: true,
  ),
  ExperienceItem(
    period: '2021 — 2023',
    role: 'Senior Graphic Designer',
    place: 'In-house design team',
    description: 'Led logo and brand-system work for a portfolio of '
        'product launches, mentoring junior designers and setting the '
        'visual language for packaging and social campaigns.',
  ),
  ExperienceItem(
    period: '2019 — 2021',
    role: 'Junior Illustrator',
    place: 'Creative agency',
    description: 'Produced character illustration and packaging art for '
        'FMCG and children\'s product clients, working directly with art '
        'directors on tight production timelines.',
  ),
  ExperienceItem(
    period: '2018 — 2019',
    role: 'Graphic Design Intern',
    place: 'Design studio',
    description: 'First hands-on studio experience — logo exploration, '
        'print layout, and learning how a brand system holds together '
        'across many touchpoints.',
  ),
];

class ExperienceSection extends StatelessWidget {
  final bool isMobile;
  const ExperienceSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 110,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(
            child: const SectionHeading(
              eyebrow: 'EXPERIENCE',
              title: 'Where the work\nhas taken me.',
              subtitle: 'A quick look at the studios and roles that shaped '
                  'how I design today.',
            ),
          ),
          const SizedBox(height: 48),
          _Timeline(items: kExperienceItems, isMobile: isMobile),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final List<ExperienceItem> items;
  final bool isMobile;
  const _Timeline({required this.items, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        final isLast = i == items.length - 1;
        return RevealOnScroll(
          delay: Duration(milliseconds: 90 * i),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rail: dot + connecting line.
                SizedBox(
                  width: 26,
                  child: Column(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: item.current ? AppColors.violetGradient : null,
                          color: item.current ? null : AppColors.surfaceRaised,
                          border: Border.all(
                            color: item.current
                                ? Colors.transparent
                                : AppColors.orchid.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 22),
                // Card content.
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 40),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.cardGradient,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            runSpacing: 8,
                            children: [
                              Text(item.period, style: AppFonts.label(size: 12.5)),
                              if (item.current)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.violetGradient,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    'PRESENT',
                                    style: AppFonts.label(
                                      size: 10,
                                      color: AppColors.bgDeep,
                                      letterSpacing: 1.4,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.role,
                            style: AppFonts.display(size: 20, weight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.place,
                            style: AppFonts.body(
                              size: 14,
                              weight: FontWeight.w600,
                              color: AppColors.orchid,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(item.description, style: AppFonts.body(size: 14.5)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 500.ms, delay: (90 * i).ms);
      }),
    );
  }
}
