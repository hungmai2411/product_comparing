import 'dart:developer';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:compare_product/data/interfaces/i_service_api.dart';
import 'package:compare_product/data/models/voucher.dart';
import 'package:compare_product/data/network/base_api_service.dart';
import 'package:compare_product/data/network/network_api_service.dart';
import 'package:http/http.dart' as http;

class VoucherRepository extends IServiceAPI {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<List<Voucher>> getVouchersAtGearVN() async {
    try {
      String url = 'https://gearvn.com/pages/khuyen-mai';

      final responseFromGearVN = await http.get(Uri.parse(url));

      final soup = BeautifulSoup(responseFromGearVN.body);
      final items = soup.findAll("div", class_: "ladi-element");
      List<Voucher> vouchers = [];

      for (var item in items) {
        if (item.id.contains("GROUP")) {
          Voucher voucher = Voucher(thumbnail: '', title: '', link: '');
          final name = item.find("h3", class_: "ladi-headline")!.text;
          final imageTag = item.find("div", class_: "ladi-image-background");
          final image =
              "https://w.ladicdn.com/s750x500/5bf3dc7edc60303c34e4991f/lp-fix-04-20230613083547-xxnhv.png";

          voucher = voucher.copyWith(
            title: name,
            thumbnail: image,
          );
          vouchers.add(voucher);
        }
      }

      return vouchers;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<Voucher>> getVouchersAtPhongVu() async {
    try {
      String url = 'https://phongvu.vn/p/promo';

      final responseFromPhongVu = await http.get(Uri.parse(url));

      final soup = BeautifulSoup(responseFromPhongVu.body);
      final items = soup.findAll("div", class_: "bg-lazy css-odz4ex");
      List<Voucher> vouchers = [];
      int i = 0;

      for (var item in items) {
        if (i > 2) {
          for (var itemPromo in item.children) {
            for (var promo in itemPromo.children) {
              Voucher voucher = Voucher(thumbnail: '', title: '', link: '');
              var title = promo.find("div", class_: " css-1qdppk0");
              var link = promo.a != null ? promo.a!['href'] : '';
              voucher = voucher.copyWith(
                title: title!.text,
                thumbnail: promo.img != null ? promo.img!['src'] : '',
                link: link,
              );

              vouchers.add(voucher);
            }
          }
        }
        i++;
      }

      return vouchers;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  @override
  convertToObject(value) {
    throw UnimplementedError();
  }
}
