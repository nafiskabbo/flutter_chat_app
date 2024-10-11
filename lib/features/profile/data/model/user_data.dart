class UserData {
  final String? id;
  final String email;
  final DateTime? createdAt; // Nullable

  const UserData({
    this.id,
    required this.email,
    this.createdAt, // Nullable
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] as String?,
      email: map['email'] as String,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'email': email,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
