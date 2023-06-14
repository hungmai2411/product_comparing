import 'package:compare_product/presentation/helper/loading/loading_screen.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/dimensions.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/services/alert_bloc/alert_bloc.dart';
import 'package:compare_product/presentation/utils/functions.dart';
import 'package:compare_product/presentation/utils/money_extension.dart';
import 'package:compare_product/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReceiveAlertScreen extends StatefulWidget {
  final String link;

  const ReceiveAlertScreen({
    super.key,
    required this.link,
  });

  @override
  State<ReceiveAlertScreen> createState() => _ReceiveAlertScreenState();
}

class _ReceiveAlertScreenState extends State<ReceiveAlertScreen> {
  RangeValues priceRange = const RangeValues(0, 110000000);
  AlertBloc get _bloc => BlocProvider.of<AlertBloc>(context);
  final TextEditingController _mailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _mailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0.3,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.secondary,
          ),
        ),
        title: Text(
          'Set an Alert',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<AlertBloc, AlertState>(
        listener: (context, state) {
          if (state is AlertLoading) {
            LoadingScreen().show(context: context);
          } else if (state is AlertFailure) {
            LoadingScreen().hide();
            showSnackBar(
              context,
              state.errorMessage,
              const Icon(
                Icons.check,
              ),
            );
          } else {
            LoadingScreen().hide();

            Navigator.of(context).pop();
            showSnackBar(
              context,
              'Register alert successfully',
              const Icon(
                Icons.check,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Price Range',
                  style: AppStyles.semibold,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    boxMoney(priceRange.start.round()),
                    const SizedBox(width: 10),
                    boxMoney(priceRange.end.round()),
                  ],
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: RangeSlider(
                    min: 0,
                    max: 110000000,
                    values: priceRange,
                    activeColor: AppColors.primary,
                    onChanged: (RangeValues values) {
                      if (mounted) {
                        setState(() {
                          priceRange = values;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Email to receive alert',
                  style: AppStyles.semibold,
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _mailController,
                  enabled: true,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: AppColors.primary),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.envelope,
                        color: AppColors.primary,
                        size: 15,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.secondary, width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFF1D1E2C)),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  content: 'Done',
                  onTap: () {
                    String email = _mailController.text.trim();
                    if (email.isNotEmpty) {
                      _bloc.add(
                        AlertSubmitted(
                          link: widget.link,
                          mail: email,
                          max: priceRange.end.toInt(),
                          min: priceRange.start.toInt(),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget boxMoney(int money) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppColors.gray,
          ),
        ),
        child: Text(
          money.toMoney,
          textAlign: TextAlign.center,
          style: AppStyles.regular,
        ),
      ),
    );
  }
}
