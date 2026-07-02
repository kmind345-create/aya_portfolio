import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_heading.dart';
import '../widgets/tilt_3d_card.dart';

class ServiceItem {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  const ServiceItem({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });
}

const _services = [
  ServiceItem(
    number: '01',
    title: 'Logo Design',
    description: 'A distinct, scalable mark built from one strong idea — '
        'designed to work as a favicon or a storefront sign.',
    icon: Icons.diamond_outlined,
  ),
  ServiceItem(
    number: '02',
    title: 'Illustration & Packaging',
    description: 'Warm, character-driven illustration for packaging, '
        'editorial, and product art — consistent across every piece.',
    icon: Icons.brush_outlined,
  ),
  ServiceItem(
    number: '03',
    title: 'Visual Identity',
    description: 'Color, type, and pattern tied to the mark, so every '
        'touchpoint feels unmistakably yours.',
    icon: Icons.palette_outlined,
  ),
];

class ServicesSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  const ServicesSection({
    super.key,
    required this.isMobile,
    required this.isTablet,
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
              eyebrow: 'WHAT I DO',
              title: 'Three ways we\ncan work together.',
            ),
          ),
          const SizedBox(height: 48),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _services.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 26,
              mainAxisSpacing: 26,
              childAspectRatio: isMobile ? 1.25 : 1.25,
            ),
            itemBuilder: (context, i) {
              final s = _services[i];
              return RevealOnScroll(
                delay: Duration(milliseconds: 100 * i),
                child: Tilt3DCard(
                  maxTiltDegrees: 8,
                  borderRadius: BorderRadius.circular(26),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: const BoxDecoration(
                      gradient: AppColors.cardGradient,
                    ),
                    child: Stack(
                      children: [
                        // Decorative oversized icon ghosted in the background,
                        // fills the empty space instead of leaving it blank.
                        Positioned(
                          right: -16,
                          bottom: -16,
                          child: Icon(
                            s.icon,
                            size: 130,
                            color: Colors.white.withOpacity(0.05),
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
                                    gradient: AppColors.violetGradient,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(s.icon, color: AppColors.bgDeep, size: 24),
                                ),
                                Text(s.number,
                                    style: AppFonts.label(
                                        size: 13, color: AppColors.creamDim)),
                              ],
                            ),
                            const SizedBox(height: 26),
                            Text(
                              s.title,
                              style: AppFonts.display(size: 21, weight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            Text(s.description, style: AppFonts.body(size: 14.5)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
