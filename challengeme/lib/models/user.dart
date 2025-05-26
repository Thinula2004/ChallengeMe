class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final int? score;
  final int challengeCount;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.challengeCount,
    this.score,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      challengeCount: json['challengeCount'] ?? 0,
      score:
          json['score'] != null ? int.tryParse(json['score'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'score': score,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role, score: $score, challenges: $challengeCount)';
  }

  String capitalizedRole() {
    String capitalized = role[0].toUpperCase() + role.substring(1);
    return capitalized;
  }
}
