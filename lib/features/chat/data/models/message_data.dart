class MessageData {
  final String? id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime? createdAt;
  final DateTime? headerDate;

  MessageData({
    this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    this.createdAt, // Nullable
    this.headerDate, // Nullable
  });

  factory MessageData.fromMap(Map<String, dynamic> map) {
    return MessageData(
      id: map['id'] as String?,
      chatId: map['chat_id'] as String,
      senderId: map['sender_id'] as String,
      content: map['content'] as String,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'content': content,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
