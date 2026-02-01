class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final String? address;
  final DateTime createdAt;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.address,
    required this.createdAt,
  });

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'address': address,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Create from JSON
  factory UserProfile.fromJson(Map<dynamic, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      photoUrl: json['photoUrl'] as String?,
      address: json['address'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    );
  }

  // Create a copy with updated fields
  UserProfile copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? address,
    DateTime? createdAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
