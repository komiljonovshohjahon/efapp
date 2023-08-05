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

  String getSubstrDate(DateTime d) {
    try {
      return DateFormat("MMM yyyy").format(d);
    } catch (e) {
      return '';
    }
  }

  //copyWith
  BlogMd copyWith({
    String? title,
    String? description,
    String? imagePath,
  }) {
    return BlogMd(
      id: id,
      createdAt: createdAt,
      substr_date: substr_date,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }

//fromMap
  factory BlogMd.fromMap(Map<String, dynamic> map) {
    return BlogMd(
      id: map['id'] as String,
      createdAt: map['created_at'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imagePath: map['image'] ?? '',
      substr_date: map['substr_date'] ?? '',
    );
  }

//toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt,
      'title': title,
      'description': description,
      'image': imagePath,
      'substr_date': substr_date,
    };
  }

  //init
  static BlogMd init() {
    return BlogMd(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now().toIso8601String(),
      title: '',
      description: '',
      imagePath: '',
      substr_date: DateFormat("MMM yyyy").format(DateTime.now()),
    );
  }
}
