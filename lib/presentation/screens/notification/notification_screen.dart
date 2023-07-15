import 'package:compare_product/data/models/notification.dart';
import 'package:compare_product/data/models/wishlist.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/dimensions.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/screens/notification/components/item_notification.dart';
import 'package:compare_product/presentation/screens/web_view/web_view_product_screen.dart';
import 'package:compare_product/presentation/screens/wish_list/components/item_wishlist.dart';
import 'package:compare_product/presentation/services/wishlist_bloc/wishlist_bloc.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatefulWidget {
  final List<Notification> notifications;

  const NotificationScreen({
    super.key,
    required this.notifications,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0.3,
        centerTitle: true,
        title: Text(
          'Notification',
          style: AppStyles.semibold.copyWith(
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.secondary,
          ),
        ),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  Notification notification = widget.notifications[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              WebViewProductScreen(url: notification.link),
                        ),
                      );
                    },
                    child: ItemNotification(notification: notification),
                  );
                },
                itemCount: widget.notifications.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
