import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/work_items.dart';
import '../models/project.dart';
import '../services/projects_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_heading.dart';
import '../widgets/tilt_3d_card.dart';

/// Turns the bundled placeholder [kWorkItems] into [Project]s, used as a
/// fallback so the grid isn't empty before Supabase is configured (or if a
/// fetch fails).
List<Project> _fallbackProjects() => List.generate(kWorkItems.length, (i) {
      final w = kWorkItems[i];
      return Project(
        id: 'local-$i',
        title: w.title,
        client: w.client,
        category: w.category,
        imageUrl: w.image,
        sortOrder: i,
      );
    });

class PortfolioSection extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  const PortfolioSection({
    super.key,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  State<PortfolioSection> createState() => _PortfolioSectionState();
}

class _PortfolioSectionState extends State<PortfolioSection> {
  WorkCategory? _filter;
  late Future<List<Project>> _future;

  @override
  void initState() {
    super.initState();
    _future = ProjectsRepository.fetchAll().then(
      (projects) => projects.isEmpty ? _fallbackProjects() : projects,
      onError: (_) => _fallbackProjects(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Project>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 80),
            child: Center(child: CircularProgressIndicator(color: AppColors.violetPop)),
          );
        }
        return _buildGrid(context, snapshot.data ?? const <Project>[]);
      },
    );
  }

  Widget _buildGrid(BuildContext context, List<Project> allItems) {
    final items = allItems
        .where((w) => _filter == null || w.category == _filter)
        .toList(growable: false);

    final columns = widget.isMobile ? 1 : (widget.isTablet ? 2 : 3);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 24 : 80,
        vertical: widget.isMobile ? 60 : 110,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(
            child: SectionHeading(
              eyebrow: 'SELECTED WORK',
              title: 'Illustration & logo\nprojects.',
              subtitle: 'A mix of brand marks and illustrated worlds — '
                  'each one built around one clear idea, simplified until '
                  'it sticks.',
            ),
          ),
          const SizedBox(height: 34),
          RevealOnScroll(
            child: Wrap(
              spacing: 12,
              children: [
                _FilterChip(
                  label: 'All work',
                  selected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                _FilterChip(
                  label: 'Illustration',
                  selected: _filter == WorkCategory.illustration,
                  onTap: () => setState(() => _filter = WorkCategory.illustration),
                ),
                _FilterChip(
                  label: 'Logo design',
                  selected: _filter == WorkCategory.logo,
                  onTap: () => setState(() => _filter = WorkCategory.logo),
                ),
                _FilterChip(
                  label: 'Packaging',
                  selected: _filter == WorkCategory.packaging,
                  onTap: () => setState(() => _filter = WorkCategory.packaging),
                ),
                _FilterChip(
                  label: 'Visual identity',
                  selected: _filter == WorkCategory.visualIdentity,
                  onTap: () => setState(() => _filter = WorkCategory.visualIdentity),
                ),
                _FilterChip(
                  label: 'Visual design',
                  selected: _filter == WorkCategory.visualDesign,
                  onTap: () => setState(() => _filter = WorkCategory.visualDesign),
                ),
              ],
            ),
          ),
          const SizedBox(height: 42),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 28,
              mainAxisSpacing: 28,
              childAspectRatio: widget.isMobile ? 1.1 : 0.95,
            ),
            itemBuilder: (context, i) {
              final item = items[i];
              return RevealOnScroll(
                delay: Duration(milliseconds: 80 * (i % columns)),
                child: Tilt3DCard(
                  borderRadius: BorderRadius.circular(26),
                  child: _WorkCard(item: item),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WorkCard extends StatefulWidget {
  final Project item;
  const _WorkCard({required this.item});

  @override
  State<_WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<_WorkCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: item.category.gradient,
          ),
        ),
        child: Stack(
          children: [
            // Real artwork, when available, fills the card behind the
            // gradient/scrim so text stays legible on top of it. Supports
            // both a network URL (from Supabase Storage) and a bundled
            // local asset path.
            if (item.imageUrl != null)
              Positioned.fill(
                child: item.isNetworkImage
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      )
                    : Image.asset(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
              )
            else
              // Decorative oversized icon ghosted in the background,
              // used only for projects without artwork attached yet.
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  item.category.icon,
                  size: 160,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.55),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.28),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      item.category.label.toUpperCase(),
                      style: AppFonts.label(
                        size: 10.5,
                        color: Colors.white,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        style: AppFonts.display(
                          size: 22,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.client,
                        style: AppFonts.body(
                          size: 13.5,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        child: _hover
                            ? Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'View case study',
                                      style: AppFonts.label(
                                        size: 12,
                                        color: Colors.white,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.arrow_outward_rounded,
                                        size: 15, color: Colors.white),
                                  ],
                                ),
                              )
                            : const SizedBox(width: double.infinity, height: 0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.violetGradient : null,
            color: selected ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: selected ? Colors.transparent : Colors.white.withOpacity(0.12),
            ),
          ),
          child: Text(
            label,
            style: AppFonts.label(
              size: 12.5,
              color: selected ? AppColors.bgDeep : AppColors.creamDim,
              letterSpacing: 1,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
