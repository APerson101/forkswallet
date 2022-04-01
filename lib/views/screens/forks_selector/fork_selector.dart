import 'package:arbor/core/enums/supported_blockchains.dart';
import 'package:arbor/core/providers/create_wallet_provider.dart';
import 'package:arbor/views/screens/add_wallet/add_wallet_status_screen.dart';
import 'package:arbor/views/screens/forks_selector/forks_dashboard_controller.dart';
import 'package:arbor/views/screens/home/forks_dashbord.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:styled_widget/styled_widget.dart';

enum Forks { HDD, CryptoDoge, Chia }

class ForksSelector extends StatelessWidget {
  ForksSelector({Key? key}) : super(key: key);
  Rx<Forks> selectedFork = Forks.Chia.obs;

  @override
  Widget build(BuildContext context) {
    return Container();
    return Consumer<CreateWalletProvider>(builder: (_, model, __) {
      return Scaffold(
          appBar: AppBar(
              title: Text("Select Chia fork",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      fontSize: 20))),
          body: SingleChildScrollView(
            child: Center(child: _getChildren(context, model)),
          ));
    });
  }

  Widget _getChildren(BuildContext context, model) {
    List<Widget> items = [];
    ;

    items.add(SizedBox(
      height: 50,
    ));
    // var forks = Forks.values.map((fork) {
    //   String logo = fork == Forks.DogeChia
    //       ? 'dogechia_1.png'
    //       : fork == Forks.Chia
    //           ? 'chia.png'
    //           : 'flora_logo.png';
    //   supported_forks f = fork == Forks.DogeChia
    //       ? supported_forks.xdg
    //       : fork == Forks.Flora
    //           ? supported_forks.xfl
    //           : supported_forks.xch;
    return InkWell(
        onTap: () async {
          // selectedFork.value = fork;

          // model.clearAll();
          // // // //go to selector
          // model.createNewWallet(f);
          var result = await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddWalletStatusScreen(),
            ),
          );
          if (result == true) {
            Navigator.pop(context);
          }
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Container()]));
    //                     width: 75,
    //                     height: 75,
    //                     child: Image.asset(
    //                       'assets/images/$logo',
    //                       fit: BoxFit.contain,
    //                       height: 50,
    //                       width: 50,
    //                     )
    //                         .decorated(borderRadius: BorderRadius.circular(20))
    //                         .paddingAll(4))
    //                 .paddingOnly(left: 20, right: 20),
    //             Text(describeEnum(fork),
    //                     style: TextStyle(
    //                         fontWeight: FontWeight.bold,
    //                         letterSpacing: 2,
    //                         fontSize: 16))
    //                 .paddingAll(4)
    //           ])
    //           .decorated(
    //               color: Get.theme.dialogBackgroundColor,
    //               borderRadius: BorderRadius.circular(20))
    //           .paddingOnly(top: 10, bottom: 10, left: 20, right: 20));
    // }).toList();
    // items.addAll(forks);
    // items.add(SizedBox.expand());

    // return items.toColumn(mainAxisAlignment: MainAxisAlignment.spaceEvenly);
  }
}
