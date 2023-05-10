import 'package:bloc/bloc.dart';
import 'package:compare_product/presentation/enum/enum.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit()
      : super(
          const NavigationState(
            navBarItem: NavBarItem.home,
            index: 0,
          ),
        );

  void getNavBarItem(NavBarItem navBarItem) {
    switch (navBarItem) {
      case NavBarItem.home:
        emit(const NavigationState(navBarItem: NavBarItem.home, index: 0));
        break;
      case NavBarItem.vouchers:
        emit(const NavigationState(navBarItem: NavBarItem.vouchers, index: 1));
        break;
      case NavBarItem.wishlish:
        emit(const NavigationState(navBarItem: NavBarItem.wishlish, index: 2));
        break;
      case NavBarItem.profile:
        emit(const NavigationState(navBarItem: NavBarItem.profile, index: 3));
        break;
    }
  }
}
