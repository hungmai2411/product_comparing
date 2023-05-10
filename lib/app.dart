import 'package:compare_product/data/repository/product_repository.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/routes/main_routes.dart';
import 'package:compare_product/presentation/routes/routes.dart';
import 'package:compare_product/presentation/screens/bottom_navigation_bar.dart/bottom_navigation_bar_screen.dart';
import 'package:compare_product/presentation/screens/home/home_screen.dart';
import 'package:compare_product/presentation/services/product_bloc/product_bloc.dart';
import 'package:compare_product/presentation/services/search_bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/services/bottom_navigation_bloc/cubit/navigation_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List screens = [
    const HomeScreen(),
    Container(),
    Container(),
    Container(),
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(
            ProductRepository(),
          ),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(
            ProductRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Compare Product Screen',
        debugShowCheckedModeBanner: false,
        //onGenerateRoute: MainRoutes.getRoute,
        //initialRoute: Routes.home,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
        ),
        home: const BottomNavigationBarScreen(),
      ),
    );
  }
}
