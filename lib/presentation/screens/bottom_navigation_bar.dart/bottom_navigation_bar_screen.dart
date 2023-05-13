// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_local_variable
import 'dart:async';

import 'package:compare_product/presentation/enum/enum.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/screens/home/home_screen.dart';
import 'package:compare_product/presentation/screens/wish_list/wish_list_screen.dart';
import 'package:compare_product/presentation/services/bottom_navigation_bloc/cubit/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
        if (state.navBarItem == NavBarItem.home) {
          return HomeScreen();
        } else if (state.navBarItem == NavBarItem.vouchers) {
          return Container();
        } else if (state.navBarItem == NavBarItem.wishlist) {
          return WishListScreen();
        }
        return Container();
      }),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (contextx, state) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.gray,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.house,
                color:
                    state.index == 0 ? AppColors.primary : AppColors.secondary,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.gift,
                color:
                    state.index == 1 ? AppColors.primary : AppColors.secondary,
              ),
              label: 'Vouchers',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.heart,
                color:
                    state.index == 2 ? AppColors.primary : AppColors.secondary,
              ),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.user,
                color:
                    state.index == 3 ? AppColors.primary : AppColors.secondary,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: state.index,
          onTap: (index) {
            if (index == 0) {
              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.home);
            } else if (index == 1) {
              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.vouchers);
            } else if (index == 2) {
              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.wishlist);
            } else {
              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.profile);
            }
          },
        );
      }),
    );
  }
}
