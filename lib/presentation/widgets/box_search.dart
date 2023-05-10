import 'package:compare_product/presentation/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BoxSearch extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback callback;
  final Function(String) onSubmitted;

  const BoxSearch({
    super.key,
    required this.searchController,
    required this.callback,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: callback,
      controller: searchController,
      enabled: true,
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyle(color: AppColors.primary),
        prefixIcon: Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            FontAwesomeIcons.magnifyingGlass,
            color: AppColors.primary,
            size: 15,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondary, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
      ),
      style: const TextStyle(color: Color(0xFF1D1E2C)),
      onChanged: (value) {},
      onSubmitted: (String submitValue) {
        onSubmitted(submitValue);
      },
    );
  }
}
