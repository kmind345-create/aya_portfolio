/// A message submitted through the contact form. Mirrors a row in the
/// `messages` Supabase table.
class ContactMessage {
  final String id;
  final String name;
  final String email;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory ContactMessage.fromMap(Map<String, dynamic> map) {
    return ContactMessage(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      message: map['message'] as String,
      isRead: map['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
