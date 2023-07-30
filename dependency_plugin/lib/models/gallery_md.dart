//created_at
// "2018-11-20 10:33:09"
// (string)
// id
// "11"
// image
// "gallery/jNyD7Z_1542706389.png"
// title
// "Evans' Car Accident"
// updated_at

class GalleryMd {
  final String id;
  final String image;
  final String title;
  final String createdAt;

  const GalleryMd({
    required this.id,
    required this.image,
    required this.title,
    required this.createdAt,
  });

  //copyWith
  GalleryMd copyWith({
    String? id,
    String? image,
    String? title,
    String? createdAt,
  }) {
    return GalleryMd(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }

//fromMap
  factory GalleryMd.fromMap(Map<String, dynamic> map) {
    return GalleryMd(
      id: map['id'] as String,
      image: map['image'] as String,
      title: map['title'] as String,
      createdAt: map['created_at'] as String,
    );
  }

//toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'created_at': createdAt,
    };
  }

  //init
  static GalleryMd init() {
    return const GalleryMd(
      id: '',
      image: '',
      title: '',
      createdAt: '',
    );
  }
}
