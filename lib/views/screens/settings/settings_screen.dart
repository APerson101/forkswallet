import 'dart:io';

import 'package:arbor/api/responses.dart';
import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/arbor_constants.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/core/providers/settings_provider.dart';
import 'package:arbor/views/widgets/dialogs/arbor_alert_dialog.dart';
import 'package:arbor/views/widgets/dialogs/arbor_info_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo? packageInfo;
  String appVersion = "";

  @override
  void initState() {
    _getAppDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (_, model, __) {
      return Container(
        height: MediaQuery.of(context).size.height,
        color: Get.theme.backgroundColor,
        child: SafeArea(
          child: Scaffold(
            body: Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "General",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            // color: ArborColors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        settingsItem(
                          title: "Join Discord Channel",
                          assetPath: AssetPaths.discord,
                          onPressed: () => model.launchURL(
                              url: ArborConstants.discordChannelURL),
                        ),
                        settingsItem(
                          title: "Privacy Policy",
                          assetPath: AssetPaths.privacyPolicy,
                          onPressed: () => model.launchURL(
                              url: ArborConstants.websitePrivacyURL),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Data",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            // color: ArborColors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        settingsItem(
                          title: "Delete Wallet Data",
                          assetPath: AssetPaths.delete,
                          onPressed: () async {
                            await deleteData(model);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'v$appVersion',
                    style: TextStyle(
                      color: ArborColors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget settingsItem(
      {required String title,
      required String assetPath,
      required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          //constraints: BoxConstraints(maxWidth: 500, minWidth: 250),
          padding: EdgeInsets.all(
            10,
          ),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            border: Border.all(color: Get.theme.backgroundColor)
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: SvgPicture.asset(assetPath,
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                ),
                SizedBox(width: 12),
                Text(
                  "$title",
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ])),
    );
  }

  void _getAppDetails() async {
    packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo!.version;
  }

  deleteData(SettingsProvider model) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ArborAlertDialog(
          title: "Delete Your Data",
          subTitle:
              "You cannot undo this action. Do you want to proceed to delete all Arbor data?",
          onCancelPressed: () => Navigator.pop(context, false),
          onYesPressed: () => Navigator.pop(context, true),
        );
      },
    );
    if (result == true) {
      BaseResponse response = await model.deleteArborData();
      if (response.success == true) {
        showDeleteArborInfo(context,
            title: "Arbor Data Deleted",
            description: "${response.error}", onPressed: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        });
      } else {
        showDeleteArborInfo(context,
            title: "Erase Arbor Data Failed",
            description: "${response.error}",
            onPressed: null);
      }
    }
  }

  void showDeleteArborInfo(BuildContext context,
      {required String title,
      required String description,
      required VoidCallback? onPressed}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ArborInfoDialog(
          title: title,
          description: description,
          onPressed: onPressed,
        );
      },
    );
  }
}
