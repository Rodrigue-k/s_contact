class ContactModel {
  String? id;
  String name;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? company;
  String? jobTitle;
  String? address;
  String? website;
  String? note;

  ContactModel({
    this.id,
    required this.name,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.company,
    this.jobTitle,
    this.address,
    this.website,
    this.note,
  });

  // Constructeur pour créer un contact à partir du nom complet
  factory ContactModel.fromFullName(String fullName) {
    return ContactModel(
      name: fullName,
      firstName: _extractFirstName(fullName),
      lastName: _extractLastName(fullName),
    );
  }

  // Méthodes utilitaires pour extraire prénom et nom
  static String? _extractFirstName(String fullName) {
    final parts = fullName.trim().split(' ');
    return parts.isNotEmpty ? parts.first : null;
  }

  static String? _extractLastName(String fullName) {
    final parts = fullName.trim().split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : null;
  }

  // Convertir en Map pour le stockage local
  Map<String, String?> toMap() => {
        'id': id,
        'name': name,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
        'company': company,
        'jobTitle': jobTitle,
        'address': address,
        'website': website,
        'note': note,
      };

  // Créer depuis un Map
  factory ContactModel.fromMap(Map<String, String?> map) {
    return ContactModel(
      id: map['id'],
      name: map['name'] ?? '',
      firstName: map['firstName'],
      lastName: map['lastName'],
      phone: map['phone'],
      email: map['email'],
      company: map['company'],
      jobTitle: map['jobTitle'],
      address: map['address'],
      website: map['website'],
      note: map['note'],
    );
  }

  // Vérifier si le contact a des informations essentielles
  bool hasEssentialInfo() {
    return name.isNotEmpty && (phone != null && phone!.isNotEmpty || email != null && email!.isNotEmpty);
  }

  // Obtenir le nom d'affichage (utilise le nom complet ou construit depuis prénom + nom)
  String getDisplayName() {
    if (name.isNotEmpty) return name;
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return '';
  }

  // Copier avec des modifications
  ContactModel copyWith({
    String? id,
    String? name,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? address,
    String? website,
    String? note,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      address: address ?? this.address,
      website: website ?? this.website,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'ContactModel(name: $name, phone: $phone, email: $email)';
  }
}
