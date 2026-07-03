import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../data/work_items.dart';
import '../../models/project.dart';
import '../../services/projects_repository.dart';
import '../../services/storage_repository.dart';
import '../../theme/app_theme.dart';

class ProjectFormDialog extends StatefulWidget {
  final Project? existing;
  const ProjectFormDialog({super.key, this.existing});

  @override
  State<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _client;
  late final TextEditingController _imageUrl;
  late final TextEditingController _sortOrder;
  late WorkCategory _category;
  bool _saving = false;
  bool _uploading = false;
  String? _error;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _client = TextEditingController(text: e?.client ?? '');
    _imageUrl = TextEditingController(text: e?.imageUrl ?? '');
    _imageUrl.addListener(() => setState(() {}));
    _sortOrder = TextEditingController(text: (e?.sortOrder ?? 0).toString());
    _category = e?.category ?? WorkCategory.illustration;
  }

  @override
  void dispose() {
    _title.dispose();
    _client.dispose();
    _imageUrl.dispose();
    _sortOrder.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    setState(() => _error = null);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // needed on web to get raw bytes instead of a path
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) {
      setState(() => _error = 'Couldn\'t read that file. Try another one.');
      return;
    }

    setState(() => _uploading = true);
    try {
      final url = await StorageRepository.uploadImage(
        bytes: bytes,
        fileName: file.name,
      );
      _imageUrl.text = url;
    } catch (e) {
      setState(() => _error =
          'Upload failed. Make sure the "portfolio" bucket exists and is public. $e');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final project = Project(
        id: widget.existing?.id ?? '',
        title: _title.text.trim(),
        client: _client.text.trim(),
        category: _category,
        imageUrl: _imageUrl.text.trim().isEmpty ? null : _imageUrl.text.trim(),
        sortOrder: int.tryParse(_sortOrder.text.trim()) ?? 0,
      );
      if (_isEditing) {
        await ProjectsRepository.update(widget.existing!.id, project);
      } else {
        await ProjectsRepository.create(project);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = 'Couldn\'t save. $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 440,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? 'Edit project' : 'Add project',
                  style: AppFonts.display(size: 20, color: Colors.white),
                ),
                const SizedBox(height: 20),
                _Field(controller: _title, label: 'Title', validator: _required),
                const SizedBox(height: 14),
                _Field(controller: _client, label: 'Client / type', validator: _required),
                const SizedBox(height: 14),
                DropdownButtonFormField<WorkCategory>(
                  value: _category,
                  dropdownColor: AppColors.surfaceRaised,
                  style: AppFonts.body(size: 14, color: Colors.white),
                  decoration: _decoration('Category'),
                  items: WorkCategory.values
                      .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v ?? _category),
                ),
                const SizedBox(height: 14),
                _Field(
                  controller: _imageUrl,
                  label: 'Image URL (optional)',
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _uploading ? null : _pickAndUploadImage,
                      icon: _uploading
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.violetPop,
                              ),
                            )
                          : const Icon(Icons.upload_rounded, size: 16, color: AppColors.violetPop),
                      label: Text(
                        _uploading ? 'Uploading…' : 'Upload image from device',
                        style: AppFonts.label(size: 11.5, color: AppColors.violetPop),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.violetPop.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                    if (_imageUrl.text.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _imageUrl.text,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 14),
                _Field(
                  controller: _sortOrder,
                  label: 'Sort order',
                  keyboardType: TextInputType.number,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  Text(_error!, style: AppFonts.body(size: 12.5, color: Colors.redAccent)),
                ],
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _saving ? null : () => Navigator.pop(context, false),
                      child: Text('Cancel', style: AppFonts.body(size: 13, color: AppColors.creamDim)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.violetPop,
                        foregroundColor: AppColors.bgDeep,
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.bgDeep),
                            )
                          : Text(_isEditing ? 'Save changes' : 'Add project'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: AppFonts.body(size: 13, color: AppColors.creamDim),
        filled: true,
        fillColor: AppColors.bgDeep,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.violetPop),
        ),
      );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: AppFonts.body(size: 14, color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppFonts.body(size: 13, color: AppColors.creamDim),
        filled: true,
        fillColor: AppColors.bgDeep,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.violetPop),
        ),
      ),
    );
  }
}
