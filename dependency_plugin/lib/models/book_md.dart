class BookMd {
  final String id;
  final String url;
  final String createdDate;

  const BookMd({
    required this.id,
    required this.url,
    required this.createdDate,
  });

  //copyWith
  BookMd copyWith({
    String? id,
    String? url,
    String? createdDate,
  }) {
    return BookMd(
      id: id ?? this.id,
      url: url ?? this.url,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  //from json
  factory BookMd.formJson(Map json) {
    return BookMd(
        id: json["id"], url: json['url'], createdDate: json['createdDate']);
  }

  //toJson
  Map<String, String> toJson() {
    return {
      "id": id,
      "url": url,
      "createdDate": createdDate,
    };
  }
}
