import 'package:arbor/models/models.dart';
import 'package:arbor/views/screens/home/expanded_home_page.dart';
import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpandedHomeScreen extends StatefulWidget {
  final int index;
  final Wallet wallet;

  const ExpandedHomeScreen({
    required this.index,
    required this.wallet,
  });

  @override
  _ExpandedHomeScreenState createState() => _ExpandedHomeScreenState();
}

class _ExpandedHomeScreenState extends State<ExpandedHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.backgroundColor,
            elevation: 0,
            title: Text(
              'Your Wallet',
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                // color: ArborColors.white,
              ),
            ),
            centerTitle: true,
            // backgroundColor: ArborColors.green,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: ExpandedHomePage(
                index: widget.index,
                wallet: widget.wallet,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
