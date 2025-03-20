class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String? profilePicture;
  final DateTime createdAt;
  final List<String>? favoriteCarIds;
  final List<String>? bookingHistory;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.profilePicture,
    required this.createdAt,
    this.favoriteCarIds,
    this.bookingHistory,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      profilePicture: json['profilePicture'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      favoriteCarIds: json['favoriteCarIds'] != null
          ? List<String>.from(json['favoriteCarIds'] as List)
          : null,
      bookingHistory: json['bookingHistory'] != null
          ? List<String>.from(json['bookingHistory'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profilePicture': profilePicture,
      'createdAt': createdAt.toIso8601String(),
      'favoriteCarIds': favoriteCarIds,
      'bookingHistory': bookingHistory,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profilePicture,
    DateTime? createdAt,
    List<String>? favoriteCarIds,
    List<String>? bookingHistory,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      favoriteCarIds: favoriteCarIds ?? this.favoriteCarIds,
      bookingHistory: bookingHistory ?? this.bookingHistory,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.id == id &&
      other.email == email &&
      other.name == name &&
      other.phone == phone &&
      other.profilePicture == profilePicture &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      profilePicture.hashCode ^
      createdAt.hashCode;
  }
}