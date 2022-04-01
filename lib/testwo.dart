import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:arbor/addressdetails.dart';
import 'package:arbor/core/constants/arbor_constants.dart';
import 'package:arbor/importwallet.dart';
import 'package:arbor/sendview.dart';
import 'package:arbor/views/screens/forks_selector/forks_dashboard_controller.dart';
import 'package:arbor/walletselector.dart';

import 'createwalletview.dart';
import 'models/wallet.dart';

class WalletandCllcks {
  Wallet wallet;
  Refers refe;
  WalletandCllcks({
    required this.wallet,
    required this.refe,
  });
}

enum LoadingStatus { loading, success, failure }
final boxLoader =
    StateNotifierProvider<ForksDashboardController, Wallet?>((ref) {
  return ForksDashboardController(null);
});
typedef Refers = void Function(bool);
final loadingBalanceStatus =
    FutureProvider.family<void, WalletandCllcks>((ref, wallet_clcks) async {
  var tt = await ref.watch(boxLoader.notifier).reloadWalletBalances(
        wallet: wallet_clcks.wallet,
        setRefresh: wallet_clcks.refe,
      );
  return tt;
});

final usdchia = FutureProvider((ref) async {
  var rr = ref.watch(boxLoader.notifier).getCHIAUSD();
  return rr;
});

class TestTwo extends ConsumerWidget {
  final String previousPage;
  late final Box walletBox;

  TestTwo({Key? key, required this.previousPage}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWallet = ref.watch(boxLoader);
    if (activeWallet == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    return ref.watch(usdchia).when(
        error: (error, tr) => const Center(child: Text("error")),
        loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive())),
        data: (usd_chia) {
          print(usd_chia);

          return Scaffold(
              drawer: Drawer(
                  child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  const DrawerHeader(
                      child: FlutterLogo(
                    size: 24,
                  )),
                  // ListTile(
                  //     onTap: () {},
                  //     leading: const Icon(Icons.settings),
                  //     title: const Text("Settings")),
                  ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateWalletView(
                                    previousPage: previousPage)));
                      },
                      leading: const Icon(Icons.new_label),
                      title: const Text("Create Wallet")),
                  ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImportWalletView(
                                  previousPage: previousPage,
                                )));
                      },
                      leading: const Icon(Icons.new_label),
                      title: const Text("Import Wallet")),
                ],
              )),
              body: MainBody(activeWallet: activeWallet, chiausd: usd_chia));
        });
  }
}

class MainBody extends ConsumerWidget {
  MainBody({Key? key, required this.activeWallet, required this.chiausd})
      : super(key: key);
  final Wallet? activeWallet;
  final double chiausd;
  final RxBool isRefreshing = false.obs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF737874),
                    Color(0xFF393939),
                  ]),
            ),
            child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Stack(children: [
                      Positioned.directional(
                          textDirection: TextDirection.ltr,
                          top: 5,
                          start: 0,
                          end: 0,
                          height: 25,
                          child: topBar(context, activeWallet!, ref, chiausd)),
                      Positioned(
                          top: 60,
                          left: 0,
                          right: 0,
                          child: Column(
                              children: getChildren(context, activeWallet!,
                                  chiausd: chiausd)))
                    ])))),
        Obx(() {
          if (isRefreshing.value) {
            print(isRefreshing.value);

            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child:
                      const Center(child: CircularProgressIndicator.adaptive()),
                ));
          } else {
            debugPrint("not lading anymore");
            return Container();
          }
        }),
      ],
    );
  }

  getChildren(BuildContext context, Wallet wallet, {required double chiausd}) {
    List<Widget> children = [];
    children.add(getBalance(context, wallet, chiausd));
    children.add(SizedBox(height: 40));
    children.add(DefaultTabController(
        length: 2,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: Column(
            children: [
              const TabBar(tabs: [
                Tab(
                  text: 'Assets',
                ),
                Tab(
                  text: 'History',
                ),
              ]),
              Expanded(
                child: TabBarView(children: [
                  Container(
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 20),
                        child: getCoinDetails(wallet, chiausd)),
                  ),
                  Container(
                    child: const SingleChildScrollView(
                        padding: EdgeInsets.only(top: 20),
                        child: Card(child: Text("Coming soon"))
                        //  Column(children: getTxns(context: context))
                        ),
                  ),
                ]),
              )
            ],
          ),
        )));
    // children.add(getCoinDetails());
    return children;
  }

  getBalance(BuildContext context, Wallet activeWallet, double usd_rate) {
    debugPrint("showig this page again");
    return Container(
      child: Column(
        children: [
          RichText(
              text: TextSpan(
                  text: ((activeWallet.balance) / (ArborConstants.MOJO_TO_CHIA))
                      .toString(),
                  // Text("\$19,018.474",
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  children: [
                TextSpan(
                    text: activeWallet.blockchain.ticker,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold))
              ])),
          const SizedBox(height: 40),
          ButtonBar(
            buttonMinWidth: double.infinity,
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SendView(
                            currentWallet: activeWallet,
                            usd_rate: usd_rate,
                          ))),
                  child: Text("Send"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), minimumSize: Size(150, 60))),
              ElevatedButton(
                  onPressed: () async => await Get.defaultDialog(
                      title: "Your wallet address",
                      content: Container(
                        child: Column(children: [
                          Text(activeWallet.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.grey)),
                          const SizedBox(
                            height: 15,
                          ),
                          QrImage(
                            data: activeWallet.address,
                            size: 250,
                            version: QrVersions.auto,
                          )
                        ]),
                      )),
                  child: const Text("Receive"),
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: const Size(150, 60))),
            ],
          )
        ],
      ),
    );
  }

  Widget topBar(BuildContext context, Wallet activeWallet, WidgetRef ref,
      double chia_usd) {
    StringBuffer shortenedAddress = StringBuffer();
    shortenedAddress.write(activeWallet.address.substring(0, 6));
    shortenedAddress.write('....');
    shortenedAddress.write(activeWallet.address.substring(
        activeWallet.address.length - 4, activeWallet.address.length));
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(
          onPressed: () {
            !Scaffold.of(context).isDrawerOpen
                ? Scaffold.of(context).openDrawer()
                : Navigator.pop(context);
          },
          icon: const Icon(Icons.menu)),
      GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WalletSelector(
                  chiaUsd: chia_usd, activeWallet: activeWallet))),
          child: Row(children: [
            RichText(
                textAlign: TextAlign.center,
                maxLines: 1,
                text: TextSpan(
                    text: activeWallet.blockchain.name,
                    style: Theme.of(context).textTheme.subtitle1,
                    children: [
                      TextSpan(
                          text: "$shortenedAddress",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.grey))
                    ])),
            const Icon(Icons.arrow_drop_down_outlined)
          ])),
      IconButton(
          onPressed: () {
            //show address details
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddressDetails(wallet: activeWallet)));
          },
          icon: const Icon(Icons.dashboard)),
      IconButton(
          onPressed: () async {
            debugPrint('Refresh button tapped');
            isRefreshing.value = true;
            Refers reff = (status) {
              isRefreshing.value = false;
              debugPrint("done refreshing");
            };

            ref.refresh(loadingBalanceStatus(
                WalletandCllcks(wallet: activeWallet, refe: reff)));
          },
          icon: const Icon(Icons.refresh))
    ]);
  }

  getCoinDetails(Wallet activeWallet, double chiausd) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: ListTile(
        onTap: () {},
        leading: const FlutterLogo(size: 24),
        title: Text('${activeWallet.blockchain.name.capitalizeFirst}',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white)),
        subtitle: Text(
          "\$ ${(activeWallet.balance / ArborConstants.MOJO_TO_CHIA) * chiausd}",
          softWrap: true,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Text(
            "${activeWallet.balance / ArborConstants.MOJO_TO_CHIA} ${activeWallet.blockchain.ticker.capitalize}",
            softWrap: true,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white)),
      ),
    );
  }

  List<Widget> getTxns({required BuildContext context}) {
    List<Card> txns = [];
    var dd = Card(
        child: ListTile(
      onTap: () async => await Get.defaultDialog(
        content: SizedBox(
          width: MediaQuery.of(context).size.width - 20,
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            children: const [
              Text("Block number"),
              Text("Receiver full details"),
              Text("Txn ID"),
              Text("Some hash stuffs probably"),
            ],
          ),
        ),
      ),
      leading: const Icon(Icons.send),
      title: const Text("Receiver: xch458hi43498hkjdhg4"),
      subtitle: RichText(
        text: TextSpan(
            text: "status",
            style: Theme.of(context).textTheme.subtitle1,
            children: const [TextSpan(text: "pending")]),
      ),
      trailing: const Text("\$546"),
    ));
    txns.add(dd);
    txns.add(dd);
    txns.add(dd);
    return txns;
  }
}
