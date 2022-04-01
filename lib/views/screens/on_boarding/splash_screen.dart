import 'package:arbor/createwalletview.dart';
import 'package:arbor/importwallet.dart';
// import 'package:arbor/views/screens/restore_wallet/restore_wallet_screen.dart';
import 'package:flutter/material.dart';
// import '../../../core/constants/asset_paths.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
        child: Column(
          children: [
            const Spacer(),
            FlutterLogo(
              size: 36,
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Welcome to  your multichain Wallet!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Spacer(),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(160, 70),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
=======
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
>>>>>>> 16d19c4e62f5d1b135b7c8a01020e86a7468ae13
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
<<<<<<< HEAD
                            builder: (context) => ImportWalletView(
                                  previousPage: 'splash',
                                )));
                  },
                  child: Text('I already have a wallet',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold))),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(160, 70),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text("Create new Wallet"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateWalletView(
                                previousPage: 'splash',
                              )));
                },
              ),
            ),
          ],
=======
                            builder: (context) => RestoreWalletScreen()));
                  },
                ),
              ],
            ),
          ),
>>>>>>> 16d19c4e62f5d1b135b7c8a01020e86a7468ae13
        ),
      ),
    );
  }
}
