class PillarOfFireMd {
  //id
  //createAt
  //description

  final String id;
  final String createAt;
  final String description;

  const PillarOfFireMd({
    required this.id,
    required this.createAt,
    required this.description,
  });

  //copyWith
  PillarOfFireMd copyWith({
    String? id,
    String? createAt,
    String? description,
  }) {
    return PillarOfFireMd(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      description: description ?? this.description,
    );
  }

  //fromMap
  factory PillarOfFireMd.fromMap(Map<String, dynamic> map) {
    return PillarOfFireMd(
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
  static PillarOfFireMd init() {
    return const PillarOfFireMd(
      id: '',
      createAt: '',
      description: '',
    );
  }
}
