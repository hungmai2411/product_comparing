part of 'wishlist_bloc.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistSuccess extends WishlistState {
  final List<Wishlist> wishlists;

  const WishlistSuccess({required this.wishlists});

  @override
  List<Object> get props => [wishlists];
}

class WishlistFailed extends WishlistState {
  final String error;

  const WishlistFailed({required this.error});
  @override
  List<Object> get props => [error];
}
