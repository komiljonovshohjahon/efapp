//created_at
// "2022-08-01 05:08:55"
// (string)
// date
// "2022-07-31"
// id
// "462"
// substr_date
// "Jul 2022"
// title
// "House of Deliverance - Church Service - अलौकिक विजय - Evans Francis - Hindi Video - 24-07-2022"
// updated_at
// "2022-08-01 05:08:55"
// youtube_video_id
// "OpFDnqP5C9k"

class YtVideoMd {
  final String id;
  final String createAt;
  final String title;
  final String videoId;

  const YtVideoMd({
    required this.id,
    required this.createAt,
    required this.title,
    required this.videoId,
  });

  //copyWith
  YtVideoMd copyWith({
    String? id,
    String? createAt,
    String? title,
    String? videoId,
  }) {
    return YtVideoMd(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      title: title ?? this.title,
      videoId: videoId ?? this.videoId,
    );
  }

//fromMap
  factory YtVideoMd.fromMap(Map<String, dynamic> map) {
    return YtVideoMd(
      id: map['id'] as String,
      createAt: map['create_at'] as String,
      title: map['title'] as String,
      videoId: map['youtube_video_id'] as String,
    );
  }

//toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createAt,
      'title': title,
      'youtube_video_id': videoId,
    };
  }

  //init
  static YtVideoMd init() {
    return const YtVideoMd(
      id: '',
      createAt: '',
      title: '',
      videoId: '',
    );
  }
}
