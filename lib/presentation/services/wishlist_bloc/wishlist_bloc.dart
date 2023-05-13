import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:compare_product/data/models/wishlist.dart';
import 'package:compare_product/data/repository/wishlist_repository.dart';
import 'package:equatable/equatable.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository wishlistRepository;

  WishlistBloc(this.wishlistRepository) : super(WishlistInitial()) {
    on<WishlistFetched>(_onFetched);
  }

  FutureOr<void> _onFetched(event, emit) async {
    emit(WishlistLoading());

    List<Wishlist> wishlists = await wishlistRepository.getWishlists();

    emit(WishlistSuccess(wishlists: wishlists));
  }
}
