import 'package:compare_product/app.dart';
import 'package:compare_product/data/models/wishlist.dart';
import 'package:compare_product/presentation/utils/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WishlistAdapter());
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}
