import 'package:compare_product/data/models/product.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/dimensions.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/screens/search/search_screen.dart';
import 'package:compare_product/presentation/widgets/box_search.dart';
import 'package:compare_product/presentation/widgets/item_product.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Easee Buy',
                  style: AppStyles.semibold.copyWith(
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: const Icon(
                FontAwesomeIcons.bell,
                color: AppColors.secondary,
              ),
            )
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  BoxSearch(
                    searchController: searchController,
                    callback: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SearchScreen(),
                        ),
                      );
                    },
                    onSubmitted: (s) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
