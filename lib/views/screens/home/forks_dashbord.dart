import 'package:arbor/api/services.dart';
import 'package:arbor/core/constants/arbor_constants.dart';
import 'package:arbor/core/enums/supported_blockchains.dart';
import 'package:arbor/models/wallet.dart';
import 'package:arbor/views/screens/add_wallet/add_wallet_screen.dart';
import 'package:arbor/views/screens/forks_selector/fork_controller.dart';
import 'package:arbor/views/screens/forks_selector/forks_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'home_screen.dart';

class ForksDashboard extends StatelessWidget {
  ForksDashboard({Key? key}) : super(key: key);
  ForksDashboardController controller = Get.put(ForksDashboardController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loadingStatus.value == DashLoadingStatus.loading) {
        return const Scaffold(
            body: Center(
          child: CircularProgressIndicator.adaptive(),
        ));
      } else if (controller.loadingStatus.value == DashLoadingStatus.success) {
        return ForksSummaryView();
      } else if (controller.loadingStatus.value == DashLoadingStatus.empty) {
        return const Center(
          child: Text(
            'Tap + to create a new wallet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
        );
      }
      return const Scaffold(
        body: Center(
          child: Text("unknown error occurred"),
        ),
      );
    });
  }
}

enum Forks { Flora, XFL, DogeChia, Flax, XFX }

class ForksSummaryView extends StatelessWidget {
  ForksDashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.backgroundColor,
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
          child: Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Get.theme.backgroundColor,
                  child: const Icon(
                    Icons.add,
                  ),
                  onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddWalletScreen(),
                        ),
                      )),
              body: RefreshIndicator(
                  onRefresh: () => controller.reloadWalletBalances(),
                  strokeWidth: 2.5,
                  child: Obx(() {
                    List<List> differentForks = controller.differentForks;
                    return ListView(
                      children: differentForks.map((e) {
                        String imageLink = e.first.blockchain.logo;
                        String img_url =
                            ArborConstants.baseWebsiteURL + imageLink;
                        String walletsamount = e.length > 1
                            ? "${e.length} wallets"
                            : "${e.length} wallet";
                        return InkWell(
                            onTap: () {
                              controller.selectedFork.value =
                                  e.first.blockchain.name;
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ));
                            },
                            child: Card(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 20),
                                  child: Column(children: [
                                    ListTile(
                                            leading: Container(
                                                width: 50,
                                                height: 50,
                                                child: Image.network(
                                                  img_url,
                                                  fit: BoxFit.contain,
                                                  height: 50,
                                                  width: 50,
                                                ).decorated(
                                                    shape: BoxShape.circle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20))),
                                            title: Text(
                                                e[0]
                                                    .blockchain
                                                    .ticker
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    letterSpacing: 1,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold)),
                                            subtitle: Text(
                                                e.first.blockchain.name +
                                                    '($walletsamount)'),
                                            trailing: sum(e))
                                        .padding(top: 5, bottom: 5),
                                  ]),
                                ))).padding(top: 20, bottom: 20);
                      }).toList(),
                    );
                  }))),
      ),
    );
  }

  Widget sum(List elements) {
    double sum = 0;
    elements.forEach((element) {
      sum += element.balance;
    });
    return Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text('${sum.toString()}',
            style: const TextStyle(
                letterSpacing: 0.6,
                fontWeight: FontWeight.bold,
                fontSize: 18)));
  }
}
