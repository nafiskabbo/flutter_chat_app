class Chat {
  final String id;
  final String lastMessage;
  final DateTime lastMessageTimestamp;

  Chat({required this.id, required this.lastMessage, required this.lastMessageTimestamp});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      lastMessage: json['last_message'],
      lastMessageTimestamp: DateTime.parse(json['last_message_timestamp']),
    );
  }
}
