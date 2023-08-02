class BookMd {
  final String id;
  final String url;
  final String createdDate;
  final String title;

  const BookMd({
    required this.id,
    required this.url,
    required this.createdDate,
    required this.title,
  });

  //copyWith
  BookMd copyWith({
    String? id,
    String? url,
    String? createdDate,
    String? title,
  }) {
    return BookMd(
      id: id ?? this.id,
      url: url ?? this.url,
      createdDate: createdDate ?? this.createdDate,
      title: title ?? this.title,
    );
  }

  //from json
  factory BookMd.fromJson(Map json) {
    return BookMd(
        id: json["id"],
        url: json['url'],
        createdDate: json['createdDate'],
        title: json['title']);
  }

  //toJson
  Map<String, String> toJson() {
    return {
      "id": id,
      "url": url,
      "createdDate": createdDate,
      "title": title,
    };
  }

  //init
  factory BookMd.init() {
    return const BookMd(
      id: "",
      url: "",
      createdDate: "",
      title: "",
    );
  }
}
