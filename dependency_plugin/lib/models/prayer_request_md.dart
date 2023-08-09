import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dependency_plugin/helpers.dart';

final class PrayerRequestMd {
  final String id;
  final String fullname;
  final String contactNo;
  final String email;
  final String country;
  final String state;
  final String city;
  final int prayerFor;
  String get prayerRequestName => prayerRequestTypes[prayerFor] ?? "";
  final String message;
  final String date;

  final bool isReviewedByAdmin;

  const PrayerRequestMd({
    required this.id,
    required this.fullname,
    required this.contactNo,
    required this.email,
    required this.country,
    required this.state,
    required this.city,
    required this.prayerFor,
    required this.message,
    required this.date,
    this.isReviewedByAdmin = false,
  });

  //from json
  factory PrayerRequestMd.fromJson(Map<String, dynamic> json) =>
      PrayerRequestMd(
        id: json["id"],
        fullname: json["fullname"],
        contactNo: json["contactNo"],
        email: json["email"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        prayerFor: json["prayerFor"] is String ? 0 : json["prayerFor"],
        message: json["message"],
        isReviewedByAdmin: json["isReviewedByAdmin"],
        date: json["date"],
      );

  //to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "contactNo": contactNo,
        "email": email,
        "country": country,
        "state": state,
        "city": city,
        "prayerFor": prayerFor,
        "message": message,
        "isReviewedByAdmin": isReviewedByAdmin,
        "date": date,
      };

  //copy with
  PrayerRequestMd copyWith({
    String? fullname,
    String? contactNo,
    String? email,
    String? country,
    String? state,
    String? city,
    int? prayerFor,
    String? message,
    bool? isReviewedByAdmin,
  }) {
    return PrayerRequestMd(
      id: id,
      fullname: fullname ?? this.fullname,
      contactNo: contactNo ?? this.contactNo,
      email: email ?? this.email,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      prayerFor: prayerFor ?? this.prayerFor,
      message: message ?? this.message,
      isReviewedByAdmin: isReviewedByAdmin ?? this.isReviewedByAdmin,
      date: date,
    );
  }

  //init
  factory PrayerRequestMd.init() => PrayerRequestMd(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullname: "",
        contactNo: "",
        email: "",
        country: "",
        state: "",
        city: "",
        prayerFor: 0,
        message: "",
        date: DateTime.now().toIso8601String(),
      );
}
