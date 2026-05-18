class Post {
  final int? id;
  final int userId;
  final String title;
  final String body;

  Post({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  // Convert JSON to Post object
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int?,
      userId: json['userId'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  // Convert Post object to JSON map for POST/PUT requests
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'userId': userId,
      'title': title,
      'body': body,
    };
    if (id != null) {
      data['id'] = id!;
    }
    return data;
  }
}
