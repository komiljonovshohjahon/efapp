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

//PillarMd Form (firstName, middleName, lastName, email, phone, country, amount, prayerHours)
//{
//         "id": "48",
//         "f_name": "nznznsn",
//         "m_name": "bdnbdbdbb",
//         "l_name": "bxbdnxb",
//         "email": "hehss@nznz.zz",
//         "phone": "9797799797",
//         "address": null,
//         "country": "nsnnsns",
//         "prayer_time": "12",
//         "created_at": null,
//         "updated_at": null
//       }
class PillarMdForm {
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String phone;
  final String country;
  final String amount;
  final String prayerHours;
  final String createdAt;
  final String id;

  const PillarMdForm({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.country,
    required this.amount,
    required this.prayerHours,
    required this.createdAt,
    required this.id,
  });

  //copyWith
  PillarMdForm copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? phone,
    String? country,
    String? amount,
    String? prayerHours,
    String? createdAt,
    String? id,
  }) {
    return PillarMdForm(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      amount: amount ?? this.amount,
      prayerHours: prayerHours ?? this.prayerHours,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }

  //fromMap
  factory PillarMdForm.fromMap(Map<String, dynamic> map) {
    return PillarMdForm(
      createdAt: map['created_at'] ?? "",
      amount: map['amount'] ?? "",
      country: map['country'] ?? "",
      email: map['email'] ?? "",
      firstName: map['f_name'] ?? "",
      lastName: map['l_name'] ?? "",
      middleName: map['m_name'] ?? "",
      phone: map['phone'] ?? "",
      prayerHours: map['prayer_time'] ?? "",
      id: map['id'] ?? "",
    );
  }

  //toMap
  Map<String, dynamic> toMap() {
    return {
      'created_at': createdAt,
      'amount': amount,
      'country': country,
      'email': email,
      'f_name': firstName,
      'l_name': lastName,
      'm_name': middleName,
      'phone': phone,
      'prayer_time': prayerHours,
      'id': id,
    };
  }

  //init
  static PillarMdForm init() {
    return const PillarMdForm(
      firstName: '',
      middleName: '',
      lastName: '',
      email: '',
      phone: '',
      country: '',
      amount: '',
      prayerHours: '',
      createdAt: '',
      id: '',
    );
  }
}
