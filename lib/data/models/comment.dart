class Comment {
  final int id;
  final String? author;
  final String content;
  final int rating;
  final bool isMy;

  Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.rating,
    required this.isMy
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      author: json['author'],
      content: json['content'],
      rating: json['rating'],
      isMy: json['isMy']
    );
  }
}