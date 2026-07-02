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

/// Every entry below renders its actual uploaded artwork via Image.asset
/// inside the Tilt3DCard (the earlier placeholder/empty tiles were removed).
const List<WorkItem> kWorkItems = [
  WorkItem(
    title: 'Stay Glowing in the Dark',
    client: 'Illustration art',
    category: WorkCategory.illustration,
    gradient: [AppColors.violetDeep, AppColors.violetMid],
    icon: Icons.auto_awesome_rounded,
    image: 'assets/images/illustration_art.jpg',
  ),
  WorkItem(
    title: 'Media Whale',
    client: 'Logo design',
    category: WorkCategory.logo,
    gradient: [AppColors.violetPop, AppColors.violetDeep],
    icon: Icons.play_circle_fill_rounded,
    image: 'assets/images/logo_design.png',
  ),
  WorkItem(
    title: 'Bitza Bil Kosour',
    client: 'Packaging illustration',
    category: WorkCategory.packaging,
    gradient: [AppColors.orchid, AppColors.violetLight],
    icon: Icons.inventory_2_rounded,
    image: 'assets/images/packing_illustration.png',
  ),
  WorkItem(
    title: 'Marionette Notebook',
    client: 'Visual identity',
    category: WorkCategory.visualIdentity,
    gradient: [AppColors.violetLight, AppColors.bgPurple],
    icon: Icons.palette_rounded,
    image: 'assets/images/visual_identity.png',
  ),
  // ---- Newly added real artwork, categorized by file name ----
  WorkItem(
    title: 'Qesma W Ta3zeeb',
    client: 'Packing',
    category: WorkCategory.packaging,
    gradient: [AppColors.violetDeep, AppColors.violetLight],
    icon: Icons.inventory_2_rounded,
    image: 'assets/images/packing.png',
  ),
  WorkItem(
    title: 'Sultan Al Asal Promo',
    client: 'Visual identity',
    category: WorkCategory.visualIdentity,
    gradient: [AppColors.orchid, AppColors.bgPurple],
    icon: Icons.palette_rounded,
    image: 'assets/images/visual_identity_promo.png',
  ),
  WorkItem(
    title: 'Soweqa',
    client: 'Visual',
    category: WorkCategory.visualDesign,
    gradient: [AppColors.violetLight, AppColors.violetPop],
    icon: Icons.brush_rounded,
    image: 'assets/images/visual.png',
  ),
];
