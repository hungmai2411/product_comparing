import 'package:compare_product/app.dart';
import 'package:compare_product/data/models/wishlist.dart';
import 'package:compare_product/data/service/firebase_service.dart';
import 'package:compare_product/firebase_options.dart';
import 'package:compare_product/presentation/utils/bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseService().registerNotification();
  FirebaseMessaging.onBackgroundMessage(handleMessageBackground);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  log(fcmToken!);
  await Hive.initFlutter();
  Hive.registerAdapter(WishlistAdapter());
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

Future<void> handleMessageBackground(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseService().showNotification(message);
}
