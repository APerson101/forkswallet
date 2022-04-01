import 'package:arbor/createwalletview.dart';
import 'package:arbor/importwallet.dart';
// import 'package:arbor/views/screens/restore_wallet/restore_wallet_screen.dart';
import 'package:flutter/material.dart';
// import '../../../core/constants/asset_paths.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
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
        ),
      ),
    );
  }
}
