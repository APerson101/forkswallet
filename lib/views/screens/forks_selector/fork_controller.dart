import 'package:arbor/core/providers/create_wallet_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ForkSelectorController extends GetxController {
  RxBool walletCreationStatus = false.obs;
  changeStatus(bool newStatus) {
    walletCreationStatus.value = newStatus;
  }

  createWallet() {}
}
