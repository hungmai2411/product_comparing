import 'package:compare_product/data/models/wishlist.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DbHelper {
  Future<Box> openBox(String boxName) async {
    Box box = await Hive.openBox(boxName);

    return box;
  }

  List<Wishlist> getWishlists(Box box) => box.values.toList().cast<Wishlist>();

  Future<Wishlist> addWishlist(Box box, Wishlist wishlist) async {
    int key = await box.add(wishlist);
    wishlist = wishlist.copyWith(key: key);
    await box.delete(key);
    await box.put(key, wishlist);
    return wishlist;
  }

  Future<void> delete(Box box, int key) async => await box.delete(key);
}
