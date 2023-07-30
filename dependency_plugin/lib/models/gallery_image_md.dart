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
  final String createAt;

  const GalleryImageMd({
    required this.id,
    required this.galleryId,
    required this.imagePath,
    required this.createAt,
  });

  //copyWith
  GalleryImageMd copyWith({
    String? id,
    String? galleryId,
    String? imagePath,
    String? createAt,
  }) {
    return GalleryImageMd(
      id: id ?? this.id,
      galleryId: galleryId ?? this.galleryId,
      imagePath: imagePath ?? this.imagePath,
      createAt: createAt ?? this.createAt,
    );
  }

//fromMap
  factory GalleryImageMd.fromMap(Map<String, dynamic> map) {
    return GalleryImageMd(
      id: map['id'] as String,
      galleryId: map['gallery_id'] as String,
      imagePath: map['image'] as String,
      createAt: map['created_at'] as String,
    );
  }

//toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gallery_id': galleryId,
      'image': imagePath,
      'created_at': createAt,
    };
  }

  //init
  static GalleryImageMd init() {
    return const GalleryImageMd(
      id: '',
      galleryId: '',
      imagePath: '',
      createAt: '',
    );
  }
}
