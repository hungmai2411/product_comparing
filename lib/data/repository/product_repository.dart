import 'dart:developer';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:compare_product/data/environment.dart';
import 'package:compare_product/data/interfaces/i_service_api.dart';
import 'package:compare_product/data/models/price.dart';
import 'package:compare_product/data/models/product.dart';
import 'package:compare_product/data/network/base_api_service.dart';
import 'package:compare_product/data/network/network_api_service.dart';
import 'package:compare_product/data/response/base_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductRepository extends IServiceAPI {
  String urlOrderProduct =
      'https://compareproductserver-production.up.railway.app/v1/order/create/';
  String urlGetPrices =
      'https://compareproductserver-production.up.railway.app/v1/products/';
  final BaseApiServices _apiServices = NetworkApiService();

  Future<List<Price>> getPrices(String name, int month, int year) async {
    String parsedName = name.replaceAll('/', '%2F');

    try {
      final response = await _apiServices.get(
        '$urlGetPrices$parsedName/month=$month/year=$year',
        {
          "Accept": '*/*',
          'Content-Type': 'application/json',
        },
      );
      var pricesJson = response;
      List<Price> prices = [];

      for (var map in pricesJson) {
        Price price = Price.fromMap(map);
        prices.add(price);
      }

      return prices;
    } catch (e) {
      return [];
    }
  }

  Future<List<Product>> searchProduct(String textSearch) async {
    List<Product> productsFromGearVN = [];
    List<Product> productsFromPhongVu = [];
    List<Product> productsFromHoangHa = [];
    //List<Product> productsFromTiki = [];

    try {
      productsFromGearVN = await crawlDataGearVN(textSearch);
      productsFromPhongVu = await crawlDataPhongVu(textSearch);
      productsFromHoangHa = await crawlDataHoangHa(textSearch);
      //productsFromTiki = await crawlDataTiki(textSearch);
    } catch (e) {
      log('search product: $e');
    }

    List<Product> results = [];

    results.addAll(productsFromGearVN);
    results.addAll(productsFromPhongVu);
    results.addAll(productsFromHoangHa);
    //results.addAll(productsFromTiki);

    return results;
  }

  Future<List<Product>> crawlDataGearVN(String keyword) async {
    String parsedKeyword = keyword.replaceAll(" ", "%20");
    String url =
        'https://gearvn.com/search?type=product&q=filter=((title%3Aproduct%20**%20$parsedKeyword)%7C%7C(tag%3Aproduct%3D$parsedKeyword)%7C%7C(sku%3Aproduct**$parsedKeyword))%26%26(price%3Aproduct%3E100)';
    log("gearvn url: $url");
    List<Product> products = [];

    final responseFromGearVN = await http.get(Uri.parse(url));

    final soup = BeautifulSoup(responseFromGearVN.body);
    final items =
        soup.findAll('div', class_: 'col-xl-3 col-lg-3 col-6 proloop');

    for (var item in items) {
      final urlTag = item.find('a', class_: "aspect-ratio fade-box");
      final url = urlTag!['href'];
      final name = item.find('h3', class_: 'proloop-name')?.a!['title'] ?? '';

      final imageTag = item.find('picture', class_: 'has-hover')!.children[0];

      final imgUrl = 'https:${imageTag['data-srcset']!}';

      final priceTags = item.find('div', class_: 'proloop-price');

      String originalPrice, discountPrice;

      if (priceTags!.children.length == 2) {
        originalPrice = priceTags.children[0].text;
        discountPrice = priceTags.children[1].text;
      } else {
        originalPrice = priceTags.children[0].text;
        discountPrice = "";
      }

      originalPrice = originalPrice.replaceAll('.', '');

      int index = originalPrice.indexOf("₫");

      int newOriginalPrice = int.parse(originalPrice.substring(0, index));
      int newDiscountPrice = 0;

      if (discountPrice.isNotEmpty) {
        discountPrice = discountPrice.replaceAll('.', '');

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

  Future<List<Product>> crawlDataTiki(String keyword) async {
    String parsedKeyword = keyword.replaceAll(" ", "%20");
    String url = '$tikiURL$parsedKeyword';
    log("tiki url: $url");
    List<Product> products = [];

    final responseFromTiki = await http.get(Uri.parse(url));

    final soup = BeautifulSoup(responseFromTiki.body);
    final items = soup.findAll('div');

    for (var item in items) {
      final urlTag = item.find('div',
          class_: "style__ProductLink-sc-qg694h-1 jVKZFk product-item");
      final url = urlTag!.a!['href'];
      final name = item.find('div', class_: 'ie3A+n bM+7UW Cve6sh')?.text ?? '';

      final imageTag = item.find(
        'img',
        class_: '_7DTxhh vc8g9F',
      );

      final imgUrl = imageTag!['src']!;

      final priceTags = item.find('div', class_: 'hpDKMN');

      String originalPrice, discountPrice;

      if (priceTags!.children.length > 2) {
        originalPrice = priceTags.children[0].text;
        discountPrice = priceTags.children[2].children[1].text;
      } else {
        originalPrice = priceTags.children[1].text;
        discountPrice = "";
      }

      originalPrice = originalPrice.replaceAll('.', '');

      int index = originalPrice.indexOf("₫");

      int newOriginalPrice =
          int.parse(originalPrice.substring(index + 1, originalPrice.length));
      int newDiscountPrice = 0;

      if (discountPrice.isNotEmpty) {
        newDiscountPrice = int.parse(discountPrice);
      }

      Product product = Product(
        imgUrl: imgUrl,
        name: name,
        originalPrice: newOriginalPrice,
        discountPrice: newDiscountPrice,
        shopName: 'Shopee',
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

    for (var item in items[0].contents) {
      final urlTag = item.find('div', class_: "img");
      final url = urlTag!.a!['href'];
      final name = item.find('div', class_: 'info')?.text.trimLeft() ?? '';

      final imgUrl = urlTag.a!.children[0]['src'];

      final priceTags = item.find('span', class_: 'price');

      String originalPrice, discountPrice;

      if (priceTags!.children.length > 1) {
        originalPrice = priceTags.children[1].text;
        discountPrice = priceTags.children[0].text;
      } else {
        originalPrice = priceTags.children[0].text;
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

      final technicalInfoTags = soup.findAll("tr", class_: "row-info");
      Map<String, String> technicalInfo = <String, String>{};

      for (var tag in technicalInfoTags) {
        final tagKey = tag.contents[0];
        final tagValue = tag.contents[1];
        String key = tagKey.text;
        String value = tagValue.text;
        technicalInfo[key] = value;
      }

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

  @override
  convertToObject(value) {
    throw UnimplementedError();
  }

  Future<void> orderProduct(String link, String mail, int min, int max) async {
    try {
      final response = await _apiServices.post(
        urlOrderProduct,
        {
          "link": link,
          "gmail": mail,
          "price": {
            "min": min,
            "max": max,
          },
        },
        {
          "Accept": '*/*',
          'Content-Type': 'application/json',
        },
      );
      print(response);
    } catch (e) {
      log('Error order product: $e');
    }
  }
}
