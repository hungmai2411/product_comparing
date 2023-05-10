// ignore_for_file: public_member_api_docs, sort_constructors_first
class Product {
  final String? imgUrl;
  final String? name;
  final String? description;
  final int? originalPrice;
  final int? discountPrice;
  final String? shopName;
  final String? url;
  final List<String>? images;
  final Map<String, String>? technicalInfo;

  Product({
    this.imgUrl,
    this.name,
    this.description,
    this.originalPrice,
    this.discountPrice,
    this.shopName,
    this.url,
    this.images,
    this.technicalInfo,
  });

  Product copyWith({
    String? imgUrl,
    String? name,
    String? description,
    int? originalPrice,
    int? discountPrice,
    String? shopName,
    String? url,
    List<String>? images,
    Map<String, String>? technicalInfo,
  }) {
    return Product(
      imgUrl: imgUrl ?? this.imgUrl,
      name: name ?? this.name,
      description: description ?? this.description,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      shopName: shopName ?? this.shopName,
      url: url ?? this.url,
      images: images ?? this.images,
      technicalInfo: technicalInfo ?? this.technicalInfo,
    );
  }
}
