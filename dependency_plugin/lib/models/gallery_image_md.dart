//created_at
// "2018-11-20 12:42:12"
// (string)
// gallery_id
// "14"
// id
// "87"
// image
// "gallery/4W9R1q_1542717732.jpg"
// updated_at
// "2018-11-20 12:42:12"

class GalleryImageMd {
  final String id;
  final String galleryId;
  final String imagePath;
  final String createdAt;

  const GalleryImageMd({
    required this.id,
    required this.galleryId,
    required this.imagePath,
    required this.createdAt,
  });

  //copyWith
  GalleryImageMd copyWith({
    String? galleryId,
    String? imagePath,
  }) {
    return GalleryImageMd(
      id: id,
      createdAt: createdAt,
      galleryId: galleryId ?? this.galleryId,
      imagePath: imagePath ?? this.imagePath,
    );
  }

//fromMap
  factory GalleryImageMd.fromMap(Map<String, dynamic> map) {
    return GalleryImageMd(
      id: map['id'] as String,
      galleryId: map['gallery_id'] as String,
      imagePath: map['image'] as String,
      createdAt: map['created_at'] as String,
    );
  }

//toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gallery_id': galleryId,
      'image': imagePath,
      'created_at': createdAt,
    };
  }

  //init
  static GalleryImageMd init() {
    return GalleryImageMd(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      galleryId: '',
      imagePath: '',
      createdAt: DateTime.now().toIso8601String(),
    );
  }
}
