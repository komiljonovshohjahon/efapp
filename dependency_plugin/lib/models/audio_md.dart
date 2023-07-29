//album_id
// "3"
// audio_file
// "audios/qV2oPa_1539453869.mp3"
// audio_title
// "Jesus is Alive"
// created_at
// "2018-10-13 20:04:29"
// id
// "17"
// image
// "audios/NXofJ3_1539453869.jpg"
// updated_at
// "2020-01-06 05:03:06"

final class AudioModel {
  final int albumId;
  final String audioFile;
  final String audioTitle;
  final String createdAt;
  final int id;
  final String image;
  final String updatedAt;

  const AudioModel({
    required this.albumId,
    required this.audioFile,
    required this.audioTitle,
    required this.createdAt,
    required this.id,
    required this.image,
    required this.updatedAt,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      albumId: int.parse(json['album_id']),
      audioFile: json['audio_file'],
      audioTitle: json['audio_title'],
      createdAt: json['created_at'],
      id: int.parse(json['id']),
      image: json['image'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'album_id': albumId.toString(),
      'audio_file': audioFile,
      'audio_title': audioTitle,
      'created_at': createdAt,
      'id': id.toString(),
      'image': image,
      'updated_at': updatedAt,
    };
  }
}
