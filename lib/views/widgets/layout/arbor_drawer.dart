import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/themes/theme_controller.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArborDrawer extends StatelessWidget {
  final VoidCallback? onWalletsTapped;
  final VoidCallback? onSettingsTapped;
  ArborDrawer({Key? key, this.onWalletsTapped, this.onSettingsTapped})
      : super(key: key);
  RxBool dark = Get.isDarkMode.obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 40),
      child: Drawer(
        child: Container(
          // color: ArborColors.green,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    // color: ArborColors.green,
                    ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(20),
                  child: Image.asset(AssetPaths.logo),
                ),
              ),
              ListTile(
                onTap: onWalletsTapped,
                leading: SizedBox(
                    width: 40,
                    child: Obx(() => SvgPicture.asset(
                          AssetPaths.wallet,
                          color: dark.value ? Colors.white : Colors.black,
                        ))),
                title: Text(
                  'Wallets',
                  style: TextStyle(
                    fontSize: 16.sp,
                    // color: ArborColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Divider(
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
              ListTile(
                onTap: onSettingsTapped,
                leading: SizedBox(
                  width: 40,
                  child: Obx(() => SvgPicture.asset(
                        AssetPaths.settings,
                        color: dark.value ? Colors.white : Colors.black,
                      )),
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 16.sp,
                    // color: ArborColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Spacer(),
              // Flexible(child: Container()),
              // Expanded(child: Container()),
              Padding(
                  padding: EdgeInsets.only(left: 100, right: 100, top: 250),
                  child: DayNightSwitcher(
                      isDarkModeEnabled: !Get.isDarkMode,
                      onStateChanged: (darkMode) async {
                        dark.value = !dark.value;
                        ThemeController teme = Get.find();
                        teme.dark.value = !darkMode ? true : false;
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool('theme', !darkMode ? true : false);
                        !darkMode
                            ? Get.changeTheme(ThemeData.dark())
                            : Get.changeTheme(ThemeData(
                                brightness: Brightness.light,
                                primarySwatch: Colors.purple));
                      }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
