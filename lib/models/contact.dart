// lib/models/contact.dart

class Contact {
  final String id;
  final String name;
  final String number;
  final String type;
  final bool isEmergency;

  Contact({
    required this.id,
    required this.name,
    required this.number,
    this.type = 'personal',
    this.isEmergency = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'type': type,
      'isEmergency': isEmergency,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      number: map['number'],
      type: map['type'] ?? 'personal',
      isEmergency: map['isEmergency'] ?? false,
    );
  }
}
