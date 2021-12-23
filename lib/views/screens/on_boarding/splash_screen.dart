import 'package:arbor/themes/theme_controller.dart';
import 'package:arbor/views/screens/restore_wallet/restore_wallet_screen.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../core/constants/arbor_colors.dart';
import '../../widgets/arbor_button.dart';
import '../../../core/constants/asset_paths.dart';

import 'on_boarding_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    DayNightSwitcherIcon(
                        isDarkModeEnabled: Get.isDarkMode,
                        onStateChanged: (value) async {
                          print(value);
                          value
                              ? Get.changeTheme(ThemeData.dark())
                              : Get.changeTheme(ThemeData(
                                  brightness: Brightness.light,
                                  primarySwatch: Colors.purple));
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('theme', value ? true : false);
                          ThemeController them = Get.find();
                          them.dark.value = value;
                        })
                  ],
                ),
                const Spacer(),
                Image.asset(
                  AssetPaths.logo,
                  width: 0.2.sh,
                  //height: MediaQuery.of(context).size.width * 0.5,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Secure & Easy to Use Light Chia Wallet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    // color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Obx(() {
                  return ArborButton(
                    backgroundColor: Get.theme.obs.value.backgroundColor,
                    title: 'Get Started',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnBoardingScreen()));
                    },
                  );
                }),
                SizedBox(
                  height: 20.h,
                ),
                ArborButton(
                  // backgroundColor: ArborColors.deepGreen,
                  title: 'I already have a wallet',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestoreWalletScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
