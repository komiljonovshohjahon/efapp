class PillarOfCloudMd {
  //id
  //createAt
  //description

  final String id;
  final String createAt;
  final String description;

  const PillarOfCloudMd({
    required this.id,
    required this.createAt,
    required this.description,
  });

  //copyWith
  PillarOfCloudMd copyWith({
    String? id,
    String? createAt,
    String? description,
  }) {
    return PillarOfCloudMd(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      description: description ?? this.description,
    );
  }

  //fromMap
  factory PillarOfCloudMd.fromMap(Map<String, dynamic> map) {
    return PillarOfCloudMd(
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
  static PillarOfCloudMd init() {
    return const PillarOfCloudMd(
      id: '',
      createAt: '',
      description: '',
    );
  }
}
