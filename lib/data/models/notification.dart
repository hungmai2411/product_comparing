import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Notification {
  final String link;
  final String name;
  final String image;
  final String price;
  final String id;
  Notification({
    required this.link,
    required this.name,
    required this.image,
    required this.price,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'link': link,
      'name': name,
      'image': image,
      'price': price,
      'id': id,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      link: map['link'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      price: map['price'] as String,
      id: map['_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);
}
