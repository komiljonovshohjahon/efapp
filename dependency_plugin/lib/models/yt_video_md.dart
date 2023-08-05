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

import 'package:intl/intl.dart';

class YtVideoMd {
  final String id;
  final String createdAt;
  final String title;
  final String videoId;
  String get url => "https://www.youtube.com/watch?v=$videoId";
  final String substr_date;
  DateTime? get date {
    try {
      DateTime? newDate = DateFormat("MMM yyyy").parse(substr_date);
      return newDate;
    } catch (e) {
      return null;
    }
  }

  const YtVideoMd({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.videoId,
    required this.substr_date,
  });

  //copyWith
  YtVideoMd copyWith({
    String? title,
    String? videoId,
  }) {
    return YtVideoMd(
      id: id,
      createdAt: createdAt,
      title: title ?? this.title,
      videoId: videoId ?? this.videoId,
      substr_date: substr_date,
    );
  }

//fromMap
  factory YtVideoMd.fromMap(Map<String, dynamic> map) {
    return YtVideoMd(
      id: map['id'] as String,
      createdAt: map['created_at'] as String,
      title: map['title'] as String,
      videoId: map['youtube_video_id'] as String,
      substr_date: map['substr_date'] ?? '',
    );
  }

//toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt,
      'title': title,
      'youtube_video_id': videoId,
      'substr_date': substr_date,
    };
  }

  //init
  static YtVideoMd init() {
    return YtVideoMd(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now().toIso8601String(),
      title: '',
      videoId: '',
      substr_date: DateFormat("MMM yyyy").format(DateTime.now()),
    );
  }
}
