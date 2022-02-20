import 'dart:async';
import 'dart:math';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

import 'package:arbor/core/enums/supported_blockchains.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/models/phrase.dart';
import 'core/providers/create_wallet_provider.dart';
import 'main.dart';
import 'models/wallet.dart';

enum blockchains { Chia, ChiaDoge, Flora }

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
  CreateWalletView({Key? key}) : super(key: key);
  supported_forks selectedChain = supported_forks.xch;

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
    return supported_forks.values
        .map((e) => Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                  leading: FlutterLogo(size: 24),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateStatusScreeen()));
                  },
                  title: Text(describeEnum(e),
                      style: Theme.of(context).textTheme.bodyText1)),
            ))
        .toList();
  }
}

final newWallet = FutureProvider.autoDispose((ref) async {
  // final walletProvider = CreateWalletProvider();
  // ref.watch(currentView.notifier).state = viewStates.creating;

  final createProvider = ref.watch(createWalletProvider);
  final things = createProvider.createNewWallet();
  // .then(
  //     (value) => ref.watch(currentView.notifier).state = viewStates.success);
  // ref.watch(currentView.notifier).state = viewStates.success;
  return things;
});

class CreateStatusScreeen extends ConsumerWidget {
  CreateStatusScreeen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(newWallet);

    // final viewProvider = ref.watch(currentView);

    // switch (viewProvider) {
    //   case viewStates.creating:
    //     return const Scaffold(
    //         body: Center(child: CircularProgressIndicator.adaptive()));
    //   case viewStates.success:
    //     return const Scaffold(body: Center(child: Text("success")));
    //   default:
    //     return const Text("Done");

    return ref.watch(newWallet).when(
          loading: () {
            print("loading");
            return const Scaffold(
                body: Center(child: CircularProgressIndicator.adaptive()));
          },
          data: (data) => showWalletDetails(context),
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

  Widget showWalletDetails(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
                "cotton obtain bacon nominee rich couch junk merge convince heart caught popular"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
              "this is your recover key, copy it down somewhere, do not loose it"),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(onPressed: () {}, child: Text("Copy")),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Continue")),
        ),
      ],
    );
  }
}
