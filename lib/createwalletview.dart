import 'dart:async';
import 'dart:math';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

import 'package:arbor/core/enums/supported_blockchains.dart';
import 'package:arbor/testwo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'core/models/phrase.dart';
import 'core/providers/create_wallet_provider.dart';
import 'main.dart';
import 'models/wallet.dart';

enum blockchains { Chia, DogeChia, HDD }
typedef navigat_callBack = void Function();
enum viewStates { defaultView, creating, success, failure }
final currentView = StateProvider((ref) => viewStates.defaultView);
// final changedState = Provider((ref) {
//   ref.listen<viewStates>(currentView, (previous, next) {
// final createProvider = ref.watch(createWalletProvider);
//   if (next == viewStates.creating)
//     createProvider.createNewWallet(supported_forks.xch);
// });
// });

class CreateWalletView extends ConsumerWidget {
  CreateWalletView({Key? key, required this.previousPage}) : super(key: key);
  supported_forks selectedChain = supported_forks.xch;
  final String previousPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final viewProvider = ref.watch(currentView);
    // switch (viewProvider) {
    // case viewStates.defaultView:
    return defaultView(context, ref);
    // case viewStates.creating:
    //   return const Scaffold(
    //       body: Center(child: CircularProgressIndicator.adaptive()));
    // case viewStates.failure:
    //   return Scaffold(
    //     appBar: AppBar(
    //       leading: IconButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         icon: const Icon(Icons.arrow_back_ios_new_outlined),
    //       ),
    //     ),
    //     body: Padding(
    //       padding: const EdgeInsets.all(10),
    //       child: Text("Failed to create, please try again later",
    //           style: Theme.of(context).textTheme.headline4!.copyWith(
    //               color: Colors.white, fontWeight: FontWeight.bold)),
    //     ),
    //   );
    // default:
    //   return const Scaffold(
    //     body: Padding(
    //       padding: EdgeInsets.all(10),
    //       child: Text("Unknown Error"),
    //     ),
    // );
    // }
  }

  defaultView(BuildContext context, ref) {
    return Scaffold(
        body: Stack(children: [
      Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
              leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back_ios_new)),
              title: Text("Select Blockchain",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)))),
      Positioned(
          top: 50,
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: getCards(context, ref),
            ),
          ))
    ]));
  }

  List<Card> getCards(BuildContext context, WidgetRef ref) {
    navigat_callBack call = () {
      Navigator.of(context).pop();
    };
    return supported_forks.values
        .map((e) => Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                  leading: FlutterLogo(size: 24),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateStatusScreeen(
                                coin: e,
                                previousPage: previousPage,
                                call: call)));
                  },
                  title: Text(describeEnum(e),
                      style: Theme.of(context).textTheme.bodyText1)),
            ))
        .toList();
  }
}

final newWallet = FutureProvider.family
    .autoDispose<dynamic, supported_forks>((ref, coin) async {
  // final walletProvider = CreateWalletProvider();
  // ref.watch(currentView.notifier).state = viewStates.creating;

  final createProvider = ref.watch(createWalletProvider);
  final things = await createProvider.createNewWallet(coin: coin);
  // .then(
  //     (value) => ref.watch(currentView.notifier).state = viewStates.success);
  // ref.watch(currentView.notifier).state = viewStates.success;
  return things;
});

class CreateStatusScreeen extends ConsumerWidget {
  CreateStatusScreeen(
      {Key? key,
      required this.previousPage,
      required this.coin,
      required this.call})
      : super(key: key);
  final String previousPage;
  supported_forks coin;
  navigat_callBack call;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(newWallet(coin)).when(
      loading: () {
        print("loading");
        return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()));
      },
      data: (data) {
        // ref.watch(boxLoader.notifier).setCurrentWallet(data, -1);
        return showWalletDetails(context, data, ref, call);
      },
      error: (err, stack) {
        print(err);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Failed to create, please try again later",
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
    // }
  }

  Widget showWalletDetails(BuildContext context, Wallet wallet, WidgetRef ref,
      navigat_callBack callback) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(wallet.phrase),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  "this is your recover key, copy it down somewhere, do not loose it"),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: wallet.phrase));
                    Get.snackbar('status', "phrases copied to clipbord",
                        duration: Duration(seconds: 1));
                  },
                  child: const Text("Copy")),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () async {
                    await ref
                        .watch(boxLoader.notifier)
                        .setCurrentWallet(wallet, -1)
                        .then((value) {
                      if (value) {
                        if (previousPage == 'main') {
                          callback();
                          Navigator.pop(context);
                        } else {
                          // Navigator.popUntil(
                          //     context, ModalRoute.withName('/testtwo'))
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TestTwo(previousPage: previousPage)));
                        }
                      }
                    });
                  },
                  child: const Text("Continue")),
            ),
          ],
        ),
      ),
    );
  }
}
