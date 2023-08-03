import 'package:intl/intl.dart';

class BlogMd {
  final String id;
  final String createdAt;
  final String title;
  final String description;
  final String imagePath;
  final String substr_date;
  DateTime? get date {
    try {
      DateTime? newDate = DateFormat("MMM yyyy").parse(substr_date);
      return newDate;
    } catch (e) {
      return null;
    }
  }

  const BlogMd({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.imagePath,

    ///must be Jan 2023 format [MMM yyyy]
    required this.substr_date,
  });

  //copyWith
  BlogMd copyWith({
    String? id,
    String? createdAt,
    String? title,
    String? description,
    String? imagePath,
    String? substr_date,
  }) {
    return BlogMd(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      substr_date: substr_date ?? this.substr_date,
    );
  }

//fromMap
  factory BlogMd.fromMap(Map<String, dynamic> map) {
    return BlogMd(
      id: map['id'] as String,
      createdAt: map['created_at'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imagePath: map['image'] as String,
      substr_date: map['substr_date'] ?? '',
    );
  }

//toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'substr_date': substr_date,
    };
  }

  //init
  static BlogMd init() {
    return const BlogMd(
      id: '',
      createdAt: '',
      title: '',
      description: '',
      imagePath: '',
      substr_date: '',
    );
  }
}
