import 'package:arbor/testwo.dart';
import 'package:arbor/views/screens/on_boarding/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:arbor/api/services.dart';
import 'package:arbor/core/constants/hive_constants.dart';
import 'package:arbor/models/wallet.dart';

import '../../../core/constants/arbor_constants.dart';

enum DashLoadingStatus { loading, success, failure, empty }

class ForksController {
  late final Box boxWallet;

  ForksController() {
    loadAll();
  }

  loadAll() {
    boxWallet = Hive.box(HiveConstants.walletBox);
  }

  var allWallets;
  Map<String, List<Wallet>> getWalletsSummary() {
    // if (allWallets != null) return allWallets;
    Map<String, List<Wallet>> wallet = {};
    final list = boxWallet.values.toList();
    final l = List<Wallet>.from(list);
    l.forEach((wllt) {
      print(wllt.address);
      String key = wllt.blockchain.name;
      if (wallet.containsKey(key)) {
        wallet[key]!.add(wllt);
      } else {
        final list = List<Wallet>.empty(growable: true);
        list.add(wllt);
        wallet.addAll({key: list});
      }
    });
    print("HERE ARE THE WALLET VALUES:");
    wallet.forEach((key, value) {
      value.forEach((element) {
        print({key, element.address});
      });
    });
    allWallets = wallet;

    return allWallets;
  }

  Future removeWallet(
      {required String walletAddress,
      required Wallet activeWallet,
      required BuildContext context}) async {
    int wallet_to_be_deleted_index = boxWallet.values
        .toList()
        .indexWhere((element) => (element as Wallet).address == walletAddress);

    int currentWalletIndex = boxWallet.values.toList().indexOf(activeWallet);
    await boxWallet.deleteAt(wallet_to_be_deleted_index);

    if (currentWalletIndex >= wallet_to_be_deleted_index &&
        boxWallet.length > 1) {
      final prefs = await SharedPreferences.getInstance();

      return prefs.setInt(ArborConstants.activeWalletAddress,
          prefs.getInt(ArborConstants.activeWalletAddress)! - 1);
    }
    print("NEW BOX LENGH IS ${boxWallet.length}");
    if (boxWallet.length == 0) {
      //Reset
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<Widget>(builder: (context) => SplashScreen()),
        (route) => false,
      );
    }
  }
}

class ForksDashboardController extends StateNotifier<Wallet?> {
  late final Box walletBox;
  Rx<String> selectedFork = ''.obs;
  RxList<List> differentForks = <List>[].obs;

  Rx<DashLoadingStatus> loadingStatus = DashLoadingStatus.loading.obs;

  ForksDashboardController(state) : super(state) {
    walletBox = Hive.box(HiveConstants.walletBox);

    init();
  }

  init() async {
    await getCurrentWallet();
    // getWalletsSummary();
  }

  double _chiaUSD = 0.0;

  Future<double> getCHIAUSD() async {
    WalletService walletService = WalletService();
    _chiaUSD = await walletService.getChiaUSDPRice();
    return _chiaUSD;
  }

  setCHIAUSD(double newValue) {
    _chiaUSD = newValue;
  }

  Future<bool> setCurrentWallet(Wallet wallet, int index) async {
    state = wallet;
    print(wallet.address);
    if (index == -1) index = walletBox.length - 1;
    print(index);
    final prefs = await SharedPreferences.getInstance();
    selectdWalletIndex = index;

    return prefs.setInt(ArborConstants.activeWalletAddress, index);
  }

  getCurrentWallet() async {
    final prefs = await SharedPreferences.getInstance();
    int activeWalletAddress =
        prefs.getInt(ArborConstants.activeWalletAddress) ?? -1;
    print({'the active wallet is: ', activeWalletAddress});
    if (activeWalletAddress >= 0) {
      print({"total number of wallets is: ", walletBox.length});

      state = (walletBox.getAt(activeWalletAddress) as Wallet);
      selectdWalletIndex = activeWalletAddress;
    }

    for (var wallet in walletBox.values) {
      print((wallet as Wallet).address);
    }
    return state;
  }

  int selectdWalletIndex = 0;

  // Pull to refresh wallet data
  Future<void> reloadWalletBalances(
      {required Wallet wallet, required void Function(bool) setRefresh}) async {
    loadingStatus.value = DashLoadingStatus.loading;
    print('i have been called upon');
    WalletService walletService = WalletService();

    int newBalance = await walletService.fetchWalletBalance(wallet);

    Wallet newWallet = Wallet(
      name: wallet.name,
      phrase: wallet.phrase,
      privateKey: wallet.privateKey,
      publicKey: wallet.publicKey,
      address: wallet.address,
      blockchain: wallet.blockchain,
      balance: newBalance,
    );

    walletBox.putAt(selectdWalletIndex, newWallet);
    debugPrint("new wallet balance is: ${newWallet.balance}");
    setRefresh(false);
  }
}

class WalletsCategories {
  String blockchainName;
  String balance;
  List<Wallet> wallets;
  WalletsCategories({
    required this.blockchainName,
    required this.balance,
    required this.wallets,
  });
}
