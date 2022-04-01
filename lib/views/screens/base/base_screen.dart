import 'package:arbor/views/screens/home/forks_dashbord.dart';
import 'package:arbor/views/screens/settings/settings_screen.dart';
import 'package:arbor/views/widgets/layout/arbor_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  CrossFadeState currentState = CrossFadeState.showFirst;
  String title = "Chia Forks Wallet";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          // Android back button hack
          SystemNavigator.pop();
        }
        return Future.value(true);
      },
      child: Container(
        color: Get.theme.backgroundColor,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Get.theme.backgroundColor,
              title: Text(
                '$title',
                style: TextStyle(
                    // color: ArborColors.white,
                    ),
              ),
              centerTitle: true,
              // backgroundColor: ArborColors.green,
            ),
            drawer: ArborDrawer(
              onWalletsTapped: () {
                if (currentState == CrossFadeState.showFirst) {
                  closeDrawer();
                } else {
                  setState(() {
                    title = "Chia Forks Wallet";
                    currentState = CrossFadeState.showFirst;
                    closeDrawer();
                  });
                }
              },
              onSettingsTapped: () {
                if (currentState == CrossFadeState.showSecond) {
                  closeDrawer();
                } else {
                  setState(() {
                    title = "Settings";
                    currentState = CrossFadeState.showSecond;
                    closeDrawer();
                  });
                }
              },
            ),
            body: Column(
              children: [
                Expanded(
                  child: AnimatedCrossFade(
                    firstChild: ForksDashboard(),
                    // firstChild: HomeScreen(),
                    secondChild: SettingsScreen(),
                    crossFadeState: currentState,
                    duration: const Duration(milliseconds: 300),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  closeDrawer() {
    Navigator.pop(context);
  }
}
