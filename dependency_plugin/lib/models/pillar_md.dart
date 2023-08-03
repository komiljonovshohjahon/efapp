class PillarMd {
  //id
  //createdAt
  //description

  final String id;
  final String createdAt;
  final String description;

  const PillarMd({
    required this.id,
    required this.createdAt,
    required this.description,
  });

  //copyWith
  PillarMd copyWith({
    String? id,
    String? createdAt,
    String? description,
  }) {
    return PillarMd(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
    );
  }

  //fromMap
  factory PillarMd.fromMap(Map<String, dynamic> map) {
    return PillarMd(
      id: map['id'] as String,
      createdAt: map['created_at'] as String,
      description: map['description'] as String,
    );
  }

  //toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'create_at': createdAt,
      'description': description,
    };
  }

  //init
  static PillarMd init() {
    return const PillarMd(
      id: '',
      createdAt: '',
      description: '',
    );
  }
}
