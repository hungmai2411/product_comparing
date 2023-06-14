import 'package:compare_product/data/models/wishlist.dart';
import 'package:compare_product/data/service/db_helpers.dart';

class WishlistRepository {
  final DbHelper dbHelper;

  const WishlistRepository({required this.dbHelper});

  Future<Wishlist> addWishlist(Wishlist wishlist) async {
    final box = await dbHelper.openBox("wishlists");

    return await dbHelper.addWishlist(box, wishlist);
  }

  void deleteWishlist(String name) async {
    final box = await dbHelper.openBox("wishlists");

    List<Wishlist> wishlists = await getWishlists();

    for (var wishlist in wishlists) {
      if (wishlist.name == name) {
        await dbHelper.delete(box, wishlist.key!);
        return;
      }
    }
  }

  Future<bool> isLoved(String name) async {
    List<Wishlist> wishlists = await getWishlists();

    for (var wishlist in wishlists) {
      if (wishlist.name == name) {
        return true;
      }
    }

    return false;
  }

  Future<List<Wishlist>> getWishlists() async {
    final box = await dbHelper.openBox("wishlists");
    return dbHelper.getWishlists(box);
  }
}
