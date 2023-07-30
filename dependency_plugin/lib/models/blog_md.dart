class BlogMd {
  final String id;
  final String createAt;
  final String title;
  final String description;
  final String imagePath;

  const BlogMd({
    required this.id,
    required this.createAt,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  //copyWith
  BlogMd copyWith({
    String? id,
    String? createAt,
    String? title,
    String? description,
    String? imagePath,
  }) {
    return BlogMd(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }

//fromMap
  factory BlogMd.fromMap(Map<String, dynamic> map) {
    return BlogMd(
      id: map['id'] as String,
      createAt: map['create_at'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imagePath: map['image'] as String,
    );
  }

//toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createAt': createAt,
      'title': title,
      'description': description,
      'imagePath': imagePath,
    };
  }

  //init
  static BlogMd init() {
    return const BlogMd(
      id: '',
      createAt: '',
      title: '',
      description: '',
      imagePath: '',
    );
  }
}
