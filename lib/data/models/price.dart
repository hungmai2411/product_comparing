import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Price {
  final String price;
  final String date;

  const Price({
    required this.price,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'price': price,
      'date': date,
    };
  }

  factory Price.fromMap(Map<String, dynamic> map) {
    return Price(
      price: map['price'] as String,
      date: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Price.fromJson(String source) =>
      Price.fromMap(json.decode(source) as Map<String, dynamic>);
}
