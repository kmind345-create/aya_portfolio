import '../data/work_items.dart' show WorkCategory;

/// A portfolio project. Mirrors a row in the `projects` Supabase table.
class Project {
  final String id;
  final String title;
  final String client;
  final WorkCategory category;

  /// Public URL of the artwork (e.g. from Supabase Storage), or an
  /// `assets/...` path for the bundled placeholder projects.
  final String? imageUrl;
  final int sortOrder;

  const Project({
    required this.id,
    required this.title,
    required this.client,
    required this.category,
    this.imageUrl,
    this.sortOrder = 0,
  });

  bool get isNetworkImage => imageUrl != null && imageUrl!.startsWith('http');

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as String,
      title: map['title'] as String,
      client: map['client'] as String,
      category: WorkCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => WorkCategory.illustration,
      ),
      imageUrl: map['image_url'] as String?,
      sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toInsertMap() => {
        'title': title,
        'client': client,
        'category': category.name,
        'image_url': imageUrl,
        'sort_order': sortOrder,
      };
}
