class BookMd {
  final String id;
  final String url;
  final String createdDate;
  final String title;
  final String imageUrl;

  const BookMd({
    required this.id,
    required this.url,
    required this.createdDate,
    required this.title,
    required this.imageUrl,
  });

  //copyWith
  BookMd copyWith({
    String? id,
    String? url,
    String? createdDate,
    String? title,
    String? imageUrl,
  }) {
    return BookMd(
      id: id ?? this.id,
      url: url ?? this.url,
      createdDate: createdDate ?? this.createdDate,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  //from json
  factory BookMd.fromJson(Map json) {
    return BookMd(
        id: json["id"],
        url: json['url'],
        createdDate: json['createdDate'],
        title: json['title'],
        imageUrl: json['imageUrl'] ?? "");
  }

  //toJson
  Map<String, String> toJson() {
    return {
      "id": id,
      "url": url,
      "createdDate": createdDate,
      "title": title,
      "imageUrl": imageUrl,
    };
  }

  //init
  factory BookMd.init() {
    return const BookMd(
      id: "",
      url: "",
      createdDate: "",
      title: "",
      imageUrl: "",
    );
  }
}
