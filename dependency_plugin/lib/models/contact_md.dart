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

class ContactMd {
  final String id;
  final String createdAt;
  final String fullName;
  final String email;
  final String phone;
  final String message;

  const ContactMd({
    required this.id,
    required this.createdAt,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.message,
  });

  //copyWith
  ContactMd copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? message,
  }) {
    return ContactMd(
      id: id,
      createdAt: createdAt,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      message: message ?? this.message,
    );
  }

//fromMap
  factory ContactMd.fromMap(Map<String, dynamic> map) {
    return ContactMd(
      id: map['id'],
      createdAt: map['created_at'],
      fullName: map['full_name'],
      email: map['email'],
      phone: map['phone'],
      message: map['message'],
    );
  }

//toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'message': message,
    };
  }

  //init
  static ContactMd init() {
    return ContactMd(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now().toIso8601String(),
      email: "",
      fullName: "",
      message: "",
      phone: "",
    );
  }
}
