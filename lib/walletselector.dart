import 'package:arbor/main.dart';
import 'package:arbor/views/screens/forks_selector/forks_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'core/constants/arbor_constants.dart';
import 'models/wallet.dart';
import 'testwo.dart';

class WalletSelector extends ConsumerWidget {
  WalletSelector({Key? key, required this.chiaUsd, required this.activeWallet})
      : super(key: key);
  RxList<bool> panelsOpen = List<bool>.filled(3, false).obs;
  Wallet activeWallet;
  double chiaUsd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //get all wallets
    final controller = ref.watch(allWalletsController);

    final allWallets = controller.getWalletsSummary();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.keyboard_backspace_rounded)),
          title: Text("Select Account",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Obx(() => ExpansionPanelList(
                expansionCallback: (panel, status) {
                  panelsOpen[panel] = !panelsOpen[panel];
                },
                children:
                    getPanelChildren(allWallets, context, ref, controller),
              )),
        ));
  }
  //dollar equivalent API

  List<ExpansionPanel> getPanelChildren(Map<String, List<Wallet>> allWallets,
      BuildContext context, WidgetRef ref, ForksController controller) {
    List<ExpansionPanel> all = [];
    int index = 0;
    allWallets.forEach((blockchain, wallets) {
      double balance = 0.0;
      wallets.forEach((element) {
        balance += element.balance;
      });
      all.add(ExpansionPanel(
        canTapOnHeader: true,
        isExpanded: panelsOpen[index],
        headerBuilder: (context, isOpen) {
          return ListTile(
            leading: const FlutterLogo(
              size: 24,
            ),
            title: Text(blockchain),
            subtitle: Text(
                "\$ ${(balance / ArborConstants.MOJO_TO_CHIA) * chiaUsd}",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.grey)),
            trailing: Text("${balance / ArborConstants.MOJO_TO_CHIA}",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          );
        },
        body: Column(
          children: wallets.map((wallet) {
            StringBuffer shortenedAddress = StringBuffer();
            shortenedAddress.write(wallet.address.substring(0, 6));
            shortenedAddress.write('....');
            shortenedAddress.write(wallet.address
                .substring(wallet.address.length - 4, wallet.address.length));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: const Color.fromARGB(255, 48, 48, 48),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  onTap: () {
                    ref
                        .watch(boxLoader.notifier)
                        .setCurrentWallet(wallet, wallets.indexOf(wallet));
                    Navigator.of(context).pop();
                  },
                  leading: PopupMenuButton(
                      icon: const Icon(Icons.drag_indicator),
                      itemBuilder: (context) {
                        return List<PopupMenuItem>.filled(
                            1,
                            PopupMenuItem(
                                child: const Text('Delete Address'),
                                onTap: () async {
                                  Future.delayed(
                                      const Duration(seconds: 0),
                                      () async => await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () async {
//remove wallet
                                                        Navigator.of(context)
                                                            .pop();
                                                        await controller
                                                            .removeWallet(
                                                                activeWallet:
                                                                    activeWallet,
                                                                walletAddress:
                                                                    wallet
                                                                        .address,
                                                                context:
                                                                    context)
                                                            .then((value) {
                                                          Get.snackbar('Done',
                                                              "Wallet Removal Completed",
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2));
                                                          // Future.delayed(
                                                          //     Duration(
                                                          //         seconds: 0),
                                                          //     () => Navigator.of(
                                                          //             context)
                                                          //         .pop());
                                                        });
                                                        // Get.back();
                                                      },
                                                      child: const Text(
                                                          "Confirm")),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Cancel"))
                                                ],
                                                title: const Text(
                                                    "Confirm Address removal"),
                                                content: const Text(
                                                    "Removed addresses can't be recovered except through the phrases, make sure you remember them so as to recover next time"));
                                          }));
                                }));
                        //
                      }),
                  title: Text("$shortenedAddress"),
                  subtitle: Text(
                      "${wallet.balance / ArborConstants.MOJO_TO_CHIA} ${wallet.blockchain.ticker.capitalize}",
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.grey)),
                  trailing: Text(
                      "\$ ${(wallet.balance / ArborConstants.MOJO_TO_CHIA) * chiaUsd}",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }).toList(),
        ),
      ));
      index += 1;
    });
    return all;
  }
}
