import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/contact_message.dart';
import '../../services/messages_repository.dart';
import '../../theme/app_theme.dart';

class MessagesTab extends StatefulWidget {
  const MessagesTab({super.key});

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  late Future<List<ContactMessage>> _future;

  @override
  void initState() {
    super.initState();
    _future = MessagesRepository.fetchAll();
  }

  void _reload() {
    setState(() => _future = MessagesRepository.fetchAll());
  }

  Future<void> _toggleRead(ContactMessage m) async {
    await MessagesRepository.markRead(m.id, !m.isRead);
    _reload();
  }

  Future<void> _delete(ContactMessage m) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete this message?', style: TextStyle(color: Colors.white)),
        content: Text('This can\'t be undone.', style: AppFonts.body(size: 13, color: AppColors.creamDim)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await MessagesRepository.delete(m.id);
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
          Text('Messages', style: AppFonts.display(size: 18, color: Colors.white)),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<ContactMessage>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.violetPop));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Couldn\'t load messages.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: AppFonts.body(size: 13, color: AppColors.creamDim),
                    ),
                  );
                }
                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet.',
                      style: AppFonts.body(size: 14, color: AppColors.creamDim),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: messages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _MessageCard(
                    message: messages[i],
                    onToggleRead: () => _toggleRead(messages[i]),
                    onDelete: () => _delete(messages[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final ContactMessage message;
  final VoidCallback onToggleRead;
  final VoidCallback onDelete;

  const _MessageCard({required this.message, required this.onToggleRead, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: message.isRead ? Colors.white.withOpacity(0.06) : AppColors.violetPop.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (!message.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: const BoxDecoration(color: AppColors.violetPop, shape: BoxShape.circle),
                ),
              Expanded(
                child: Text(
                  message.name,
                  style: AppFonts.body(size: 14.5, weight: FontWeight.w600, color: Colors.white),
                ),
              ),
              Text(
                DateFormat('MMM d, yyyy · h:mm a').format(message.createdAt.toLocal()),
                style: AppFonts.body(size: 11.5, color: AppColors.creamDim),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SelectableText(
            message.email,
            style: AppFonts.body(size: 12.5, color: AppColors.orchid),
          ),
          const SizedBox(height: 10),
          Text(
            message.message,
            style: AppFonts.body(size: 13.5, color: AppColors.creamDim, height: 1.5),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: onToggleRead,
                icon: Icon(
                  message.isRead ? Icons.mark_email_unread_outlined : Icons.mark_email_read_outlined,
                  size: 16,
                  color: AppColors.creamDim,
                ),
                label: Text(
                  message.isRead ? 'Mark unread' : 'Mark read',
                  style: AppFonts.label(size: 11.5, color: AppColors.creamDim),
                ),
              ),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.redAccent),
                label: Text('Delete', style: AppFonts.label(size: 11.5, color: Colors.redAccent)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
