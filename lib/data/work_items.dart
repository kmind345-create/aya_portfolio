import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum WorkCategory { illustration, logo, packaging, visualIdentity, visualDesign }

extension WorkCategoryLabel on WorkCategory {
  String get label {
    switch (this) {
      case WorkCategory.illustration:
        return 'Illustration';
      case WorkCategory.logo:
        return 'Logo Design';
      case WorkCategory.packaging:
        return 'Packaging';
      case WorkCategory.visualIdentity:
        return 'Visual Identity';
      case WorkCategory.visualDesign:
        return 'Visual Design';
    }
  }

  /// Fallback gradient + icon shown behind a project card when it has no
  /// artwork attached yet (e.g. a freshly-added project from /admin).
  List<Color> get gradient {
    switch (this) {
      case WorkCategory.illustration:
        return [AppColors.violetDeep, AppColors.violetMid];
      case WorkCategory.logo:
        return [AppColors.violetPop, AppColors.violetDeep];
      case WorkCategory.packaging:
        return [AppColors.orchid, AppColors.violetLight];
      case WorkCategory.visualIdentity:
        return [AppColors.violetLight, AppColors.bgPurple];
      case WorkCategory.visualDesign:
        return [AppColors.violetLight, AppColors.violetPop];
    }
  }

  IconData get icon {
    switch (this) {
      case WorkCategory.illustration:
        return Icons.auto_awesome_rounded;
      case WorkCategory.logo:
        return Icons.play_circle_fill_rounded;
      case WorkCategory.packaging:
        return Icons.inventory_2_rounded;
      case WorkCategory.visualIdentity:
        return Icons.palette_rounded;
      case WorkCategory.visualDesign:
        return Icons.brush_rounded;
    }
  }
}

class WorkItem {
  final String title;
  final String client;
  final WorkCategory category;
  final List<Color> gradient;
  final IconData icon;

  /// Path to a real artwork image under assets/images. Every item now
  /// carries a real image — the old gradient/icon placeholder tiles have
  /// been removed from the grid.
  final String? image;

  const WorkItem({
    required this.title,
    required this.client,
    required this.category,
    required this.gradient,
    required this.icon,
    this.image,
  });
}

/// Intentionally empty. This used to hold bundled demo/placeholder projects
/// (with images shipped inside assets/images) so the grid wasn't empty
/// before the client had added anything from Supabase. Now that the client
/// manages everything from /admin, there's nothing hard-coded here — the
/// portfolio grid only ever shows what's actually in the `projects` table.
const List<WorkItem> kWorkItems = [];
