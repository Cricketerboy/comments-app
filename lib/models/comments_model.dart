class Comment {
  final String name;
  final String email;
  final String body;

  Comment({
    required this.name,
    required this.email,
    required this.body,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'body': body,
    };
  }
}
