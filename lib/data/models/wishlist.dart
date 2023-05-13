// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
part 'wishlist.g.dart';

@HiveType(typeId: 1)
class Wishlist {
  @HiveField(0)
  final String url;
  @HiveField(1)
  final String image;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final int? key;

  const Wishlist({
    required this.url,
    required this.image,
    required this.name,
    this.key,
  });

  Wishlist copyWith({
    String? url,
    String? image,
    String? name,
    int? key,
  }) {
    return Wishlist(
      url: url ?? this.url,
      image: image ?? this.image,
      name: name ?? this.name,
      key: key ?? this.key,
    );
  }
}
