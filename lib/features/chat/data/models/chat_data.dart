class ChatData {
  final String? id;
  final String user1Id;
  final String user2Id;
  final String? lastMessage;
  final DateTime? createdAt; // Nullable
  final DateTime? updatedAt; // Nullable

  ChatData({
    this.id,
    required this.user1Id,
    required this.user2Id,
    this.lastMessage, // Nullable
    this.createdAt, // Nullable
    this.updatedAt, // Nullable
  });

  factory ChatData.fromMap(Map<String, dynamic> map) {
    return ChatData(
      id: map['id'] as String?,
      user1Id: map['user1_id'] as String,
      user2Id: map['user2_id'] as String,
      lastMessage: map['last_message'] as String?,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'] as String) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user1_id': user1Id,
      'user2_id': user2Id,
      if (lastMessage != null) 'last_message': lastMessage,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
