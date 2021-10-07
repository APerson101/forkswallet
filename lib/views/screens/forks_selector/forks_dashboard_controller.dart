import 'package:arbor/api/services.dart';
import 'package:arbor/core/constants/hive_constants.dart';
import 'package:arbor/core/enums/supported_blockchains.dart';
import 'package:arbor/models/wallet.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

enum DashLoadingStatus { loading, success, failure, empty }

class ForksDashboardController extends GetxController {
  late final Box walletBox;
  Rx<String> selectedFork = ''.obs;
  RxList<List> differentForks = <List>[].obs;

  Rx<DashLoadingStatus> loadingStatus = DashLoadingStatus.loading.obs;

  @override
  void onInit() {
    super.onInit();
    walletBox = Hive.box(HiveConstants.walletBox);
    getWalletsSummary();
  }

  getWalletsSummary() {
    // as Box<Wallet>

    differentForks.value = <List>[];
    print((walletBox).values.first.blockchain.logo);
    var dogechiaWallets = walletBox.values.where((element) =>
        element.blockchain.ticker == describeEnum(supported_forks.xdg));
    var flaxWallets = walletBox.values.where((element) =>
        element.blockchain.ticker == describeEnum(supported_forks.xfl));

    var chiaWallets = walletBox.values.where((element) =>
        element.blockchain.ticker == describeEnum(supported_forks.xch));

    if (dogechiaWallets.isNotEmpty) {
      differentForks.add(dogechiaWallets.toList());
    }
    if (flaxWallets.isNotEmpty) {
      differentForks.add(flaxWallets.toList());
    }
    if (chiaWallets.isNotEmpty) {
      differentForks.add(chiaWallets.toList());
    }

    // supported_forks.values.map((e) {
    //   var subList = walletBox.values
    //       .where((element) => element.blockchain.ticker == describeEnum(e));
    //   if (subList.isNotEmpty) {
    //     differentForks.add(subList.toList());
    //   }
    // });
    if (differentForks.isNotEmpty)
      loadingStatus.value = DashLoadingStatus.success;
    if (differentForks.isEmpty) loadingStatus.value = DashLoadingStatus.empty;
  }

  // Pull to refresh wallet data
  Future<void> reloadWalletBalances() async {
    loadingStatus.value = DashLoadingStatus.loading;
    print('i have been called upon');
    WalletService walletService = WalletService();

    for (int index = 0; index < walletBox.length; index++) {
      Wallet existingWallet = walletBox.getAt(index);
      int newBalance =
          await walletService.fetchWalletBalance(existingWallet.address);

      Wallet newWallet = Wallet(
        name: existingWallet.name,
        phrase: existingWallet.phrase,
        privateKey: existingWallet.privateKey,
        publicKey: existingWallet.publicKey,
        address: existingWallet.address,
        blockchain: existingWallet.blockchain,
        balance: newBalance,
      );

      walletBox.putAt(index, newWallet);
    }
    getWalletsSummary();
  }
}
