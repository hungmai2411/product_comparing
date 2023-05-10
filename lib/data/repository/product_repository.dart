import 'dart:developer';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:compare_product/data/environment.dart';
import 'package:compare_product/data/models/product.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  Future<List<Product>> searchProduct(String textSearch) async {
    List<Product> productsFromGearVN = [];
    List<Product> productsFromPhongVu = [];
    List<Product> productsFromHoangHa = [];

    //try {
    productsFromGearVN = await crawlDataGearVN(textSearch);
    productsFromPhongVu = await crawlDataPhongVu(textSearch);
    productsFromHoangHa = await crawlDataHoangHa(textSearch);
    // } catch (e) {
    //   log('search product: $e');
    // }

    List<Product> results = [];
    results.addAll(productsFromPhongVu);
    results.addAll(productsFromGearVN);
    results.addAll(productsFromHoangHa);

    return results;
  }

  Future<List<Product>> crawlDataGearVN(String keyword) async {
    String parsedKeyword = keyword.replaceAll(" ", "%20");
    String url = '$gearvnURL$parsedKeyword))';
    log("gearvn url: $url");
    List<Product> products = [];

    final responseFromGearVN = await http.get(Uri.parse(url));

    final soup = BeautifulSoup(responseFromGearVN.body);
    final items = soup.findAll('div',
        class_: 'col-sm-4 col-xs-12 padding-none col-fix20');

    for (var item in items) {
      final urlTag = item.find('div', class_: "product-row-img");
      final url = urlTag!.a!['href'];
      final name = item.find('h2', class_: 'product-row-name')?.text ?? '';

      final imageTag = item.find(
        'img',
        class_: 'product-row-thumbnail',
      );

      final imgUrl = 'https:${imageTag!['src']!}';

      final priceTags = item.find('div', class_: 'product-row-price pull-left');

      String originalPrice, discountPrice;

      if (priceTags!.children.length > 2) {
        originalPrice = priceTags.children[0].text;
        discountPrice = priceTags.children[2].text;
      } else {
        originalPrice = priceTags.children[1].text;
        discountPrice = "";
      }

      originalPrice = originalPrice.replaceAll(',', '');

      int index = originalPrice.indexOf("₫");

      int newOriginalPrice = int.parse(originalPrice.substring(0, index));
      int newDiscountPrice = 0;

      if (discountPrice.isNotEmpty) {
        discountPrice = discountPrice.replaceAll(',', '');

        int index = discountPrice.indexOf("₫");

        newDiscountPrice = int.parse(discountPrice.substring(0, index));
      }

      Product product = Product(
        imgUrl: imgUrl,
        name: name,
        originalPrice: newOriginalPrice,
        discountPrice: newDiscountPrice,
        shopName: 'Gear VN',
        url: "https://gearvn.com${url!}",
      );
      products.add(product);
    }

    return products;
  }

  Future<List<Product>> crawlDataHoangHa(String keyword) async {
    String parsedKeyword = keyword.replaceAll("/", "%2F");
    String parsedNextKeyword = parsedKeyword.replaceAll(" ", "+");
    String url = '$hoangHaURL$parsedNextKeyword';
    log("hoang ha url: $url");

    List<Product> products = [];

    final responseFromHoangHa = await http.get(Uri.parse(url));

    final soup = BeautifulSoup(responseFromHoangHa.body);

    final items = soup.findAll('div', class_: 'col-content lts-product');

    for (var item in items) {
      final urlTag = item.find('div', class_: "img");
      final url = urlTag!.a!['href'];
      final name = item.find('div', class_: 'info')?.text ?? '';

      final imgUrl = urlTag.a!.children[0]['src'];

      final priceTags = item.find('span', class_: 'price');

      String originalPrice, discountPrice;

      if (priceTags!.children.length > 1) {
        originalPrice = priceTags.children[1].text;
        discountPrice = priceTags.children[0].text;
      } else {
        originalPrice = priceTags.children[1].text;
        discountPrice = "";
      }

      originalPrice = originalPrice.replaceAll(',', '');

      int index = originalPrice.indexOf("₫");

      int newOriginalPrice = int.parse(originalPrice.substring(0, index));
      int newDiscountPrice = 0;

      if (discountPrice.isNotEmpty) {
        discountPrice = discountPrice.replaceAll(',', '');

        int index = discountPrice.indexOf("₫");

        newDiscountPrice = int.parse(discountPrice.substring(0, index));
      }

      Product product = Product(
        imgUrl: imgUrl,
        name: name,
        originalPrice: newOriginalPrice,
        discountPrice: newDiscountPrice,
        shopName: 'Hoàng Hà Mobile',
        url: "https://hoanghamobile.com/${url!}",
      );
      products.add(product);
    }

    return products;
  }

  Future<List<Product>> crawlDataPhongVu(String textSearch) async {
    List<Product> products = [];
    String parsedKeyword = textSearch.replaceAll(" ", "+");

    try {
      String url = '$phongVuURL$parsedKeyword))';
      log('phong vu url: $url');
      final responseFromPhongVu = await http.get(Uri.parse(url));

      final soup = BeautifulSoup(responseFromPhongVu.body);
      final items = soup.findAll('div', class_: 'product-card css-35xksx');

      for (var item in items) {
        final name = item.find('h3', class_: 'css-1xdyrhj')?.text ?? '';
        final urlTag = item.find('a', class_: 'css-pxdb0j');
        final url = 'https://phongvu.vn${urlTag!['href']!}';

        final imageTag = item.find(
          'div',
          class_: 'css-1uzm8bv',
        );

        final imgUrl = imageTag!.children[0]['src']!;
        String discountPrice =
            item.find('div', attrs: {'type': 'subtitle'})?.text ?? '';
        final originalTag = item.find('div', class_: 'css-3mjppt');

        String originalPrice = "";

        if (originalTag != null) {
          for (var tag in originalTag.children) {
            if (tag.className.contains('att-product-detail-retail-price')) {
              originalPrice = tag.text;
              break;
            }
          }
        }

        if (originalPrice.isEmpty) {
          originalPrice = discountPrice;
          discountPrice = "";
        }

        originalPrice = originalPrice.replaceAll('.', '');

        int index = originalPrice.indexOf("₫");

        int newOriginalPrice = int.parse(originalPrice.substring(0, index - 1));
        int newDiscountPrice = 0;

        if (discountPrice.isNotEmpty) {
          discountPrice = discountPrice.replaceAll('.', '');

          int index = discountPrice.indexOf("₫");

          newDiscountPrice = int.parse(discountPrice.substring(0, index - 1));
        }

        Product product = Product(
          imgUrl: imgUrl,
          name: name,
          originalPrice: newOriginalPrice,
          discountPrice: newDiscountPrice,
          shopName: 'Phong Vũ',
          url: url,
        );
        products.add(product);
      }
    } catch (e) {
      log('error crawl data at phong vu: $e');
      return products;
    }

    return products;
  }

  Future<Product> getDetailProductAtPhongVu(Product product) async {
    try {
      final response = await http.get(Uri.parse(product.url!));
      final soup = BeautifulSoup(response.body);

      final imagesTag = soup.findAll("div", class_: "css-1dje825");
      List<String> imagesUrl = [];

      for (var tag in imagesTag) {
        String imgUrl = tag.contents[0]['src']!;
        imagesUrl.add(imgUrl);
      }

      final discountPriceTag = soup.find('div', class_: "css-1q5zfcu");
      var discountPrice;

      for (var tag in discountPriceTag!.contents) {
        if (tag.className.contains("att-product-detail-latest-price")) {
          discountPrice = tag.text;
        }
      }
      final originalTag = soup.find('div', class_: 'css-3mjppt');

      var originalPrice;
      if (originalTag != null) {
        for (var tag in originalTag.children) {
          if (tag.className.contains('att-product-detail-retail-price')) {
            originalPrice = tag.text;
            break;
          }
        }
      }

      Map<String, String> detailInfo = <String, String>{};
      final test1 = soup.find("div", class_: "teko-col teko-col-4 css-gr7r8o");
      final test2 = soup.find("div", class_: "css-1h28ttq");
      final detailInfoTags = soup.findAll("div", class_: "css-1i3ajxp");
      final test3 = soup.findAll("div", class_: "lazy-component");
      final test4 = soup.find("div", class_: "css-0");

      // for (var tag in detailInfoTags) {
      //   if (tag.contents.length == 2) {
      //     String key = tag.contents[0].text;
      //     String value = tag.contents[1].text;
      //     detailInfo[key] = value;
      //   } else {}
      // }

      final descriptionTag = soup.find("div", class_: "css-17aam1");
      String description = descriptionTag!.contents[0].text;

      product = product.copyWith(
        images: imagesUrl,
        description: description,
        discountPrice: discountPrice,
        originalPrice: originalPrice,
        technicalInfo: detailInfo,
      );
    } catch (e) {
      log('error at get detail at phong vu: $e');
    }

    return product;
  }

  Future<Product> getDetailProductAtGearVN(Product product) async {
    try {
      final response = await http.get(Uri.parse(product.url!));
      final soup = BeautifulSoup(response.body);

      //final imagesTag = soup.find("div", class_: "fotorama__nav__shaft");
      final technicalInfoTags = soup.findAll("tr", class_: "row-info");
      Map<String, String> technicalInfo = <String, String>{};

      for (var tag in technicalInfoTags) {
        final tagKey = tag.contents[0];
        final tagValue = tag.contents[1];
        String key = tagKey.text;
        String value = tagValue.text;
        technicalInfo[key] = value;
      }

      final differentInfoTags = soup.find("div", id: "chitiet");

      for (int i = 3; i < differentInfoTags!.contents.length; i++) {}

      product = product.copyWith(
        technicalInfo: technicalInfo,
      );
    } catch (e) {
      log('error get detail at gearvn: $e');
    }

    return product;
  }

  Future<Map<String, dynamic>?> getPriceFromPhongVu(String textSearch) async {
    Map<String, dynamic> result = <String, dynamic>{};

    List<Product> products = await crawlDataPhongVu(textSearch);

    if (products.isEmpty) {
      return null;
    }

    Product product = products[0];
    result['place'] = 'Phong Vũ';
    result['url'] = product.url;

    if (product.discountPrice == 0) {
      result['price'] = product.originalPrice;
    } else {
      result['price'] = product.discountPrice;
    }

    return result;
  }

  Future<Map<String, dynamic>?> getPriceFromHoangHa(String textSearch) async {
    Map<String, dynamic> result = <String, dynamic>{};

    List<Product> products = await crawlDataHoangHa(textSearch);

    if (products.isEmpty) {
      return null;
    }

    Product product = products[0];
    result['place'] = 'Hoàng Hà Mobile';
    result['url'] = product.url;

    if (product.discountPrice == 0) {
      result['price'] = product.originalPrice;
    } else {
      result['price'] = product.discountPrice;
    }

    return result;
  }
}
