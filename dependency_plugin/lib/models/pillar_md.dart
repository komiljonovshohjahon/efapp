class PillarMd {
  //id
  //createAt
  //description

  final String id;
  final String createAt;
  final String description;

  const PillarMd({
    required this.id,
    required this.createAt,
    required this.description,
  });

  //copyWith
  PillarMd copyWith({
    String? id,
    String? createAt,
    String? description,
  }) {
    return PillarMd(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      description: description ?? this.description,
    );
  }

  //fromMap
  factory PillarMd.fromMap(Map<String, dynamic> map) {
    return PillarMd(
      id: map['id'] as String,
      createAt: map['create_at'] as String,
      description: map['description'] as String,
    );
  }

  //toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'create_at': createAt,
      'description': description,
    };
  }

  //init
  static PillarMd init() {
    return const PillarMd(
      id: '',
      createAt: '',
      description: '',
    );
  }
}
