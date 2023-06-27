// ignore_for_file: public_member_api_docs, sort_constructors_first
class Voucher {
  final String thumbnail;
  final String title;
  final String link;
  Voucher({
    required this.thumbnail,
    required this.title,
    required this.link,
  });

  Voucher copyWith({
    String? thumbnail,
    String? title,
    String? link,
  }) {
    return Voucher(
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      link: link ?? this.link,
    );
  }
}
