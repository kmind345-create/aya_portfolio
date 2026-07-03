import 'package:flutter/material.dart';
import '../../data/work_items.dart';
import '../../models/project.dart';
import '../../services/projects_repository.dart';
import '../../theme/app_theme.dart';
import 'project_form_dialog.dart';

class ProjectsTab extends StatefulWidget {
  const ProjectsTab({super.key});

  @override
  State<ProjectsTab> createState() => _ProjectsTabState();
}

class _ProjectsTabState extends State<ProjectsTab> {
  late Future<List<Project>> _future;

  @override
  void initState() {
    super.initState();
    _future = ProjectsRepository.fetchAll();
  }

  void _reload() {
    setState(() => _future = ProjectsRepository.fetchAll());
  }

  Future<void> _openForm({Project? existing}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => ProjectFormDialog(existing: existing),
    );
    if (result == true) _reload();
  }

  Future<void> _delete(Project project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Delete "${project.title}"?', style: const TextStyle(color: Colors.white)),
        content: Text(
          'This can\'t be undone.',
          style: AppFonts.body(size: 13, color: AppColors.creamDim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ProjectsRepository.delete(project.id);
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 720;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Projects',
                  style: AppFonts.display(size: 18, color: Colors.white),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _openForm(),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add project'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.violetPop,
                  foregroundColor: AppColors.bgDeep,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Project>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.violetPop));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Couldn\'t load projects.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: AppFonts.body(size: 13, color: AppColors.creamDim),
                    ),
                  );
                }
                final projects = snapshot.data ?? [];
                if (projects.isEmpty) {
                  return Center(
                    child: Text(
                      'No projects yet — add your first one.',
                      style: AppFonts.body(size: 14, color: AppColors.creamDim),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: projects.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final p = projects[i];
                    return _ProjectRow(
                      project: p,
                      onEdit: () => _openForm(existing: p),
                      onDelete: () => _delete(p),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final Project project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProjectRow({required this.project, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 56,
              height: 56,
              child: project.imageUrl == null
                  ? Container(color: AppColors.surfaceRaised, child: const Icon(Icons.image_not_supported_outlined, color: AppColors.creamDim, size: 20))
                  : (project.isNetworkImage
                      ? Image.network(project.imageUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceRaised))
                      : Image.asset(project.imageUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceRaised))),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.title, style: AppFonts.body(size: 14.5, weight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 2),
                Text(
                  '${project.client} · ${project.category.label}',
                  style: AppFonts.body(size: 12.5, color: AppColors.creamDim),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.creamDim),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
