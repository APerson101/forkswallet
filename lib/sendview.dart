import 'package:arbor/core/constants/arbor_constants.dart';
import 'package:arbor/core/providers/send_crypto_provider.dart';
import 'package:arbor/main.dart';
import 'package:arbor/testwo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'models/models.dart';

final sendPod = FutureProvider((ref) async {
  final watcher = ref.watch(sendCryptoProvider);
  return await watcher.send();
});

class SendView extends ConsumerWidget {
  SendView({Key? key, required this.currentWallet, required this.usd_rate})
      : super(key: key);
  Wallet currentWallet;
  double usd_rate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchMan = ref.watch(sendCryptoProvider);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: getBar(context: context, currentWallet: currentWallet)),
            Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: getTextFields(
                    context: context,
                    ref: watchMan,
                    wallet: currentWallet,
                    usd_rate: usd_rate)),
          ],
        ),
      ),
    );
  }

  getBar({required BuildContext context, required Wallet currentWallet}) {
    return ListTile(
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_new)),
      title: Text("Send ${currentWallet.blockchain.ticker}",
          style: Theme.of(context).textTheme.headline6),
      trailing: FlutterLogo(size: 24),
    );
  }

  getTextFields(
      {required BuildContext context,
      required SendCryptoProvider ref,
      required Wallet wallet,
      required double usd_rate}) {
    TextEditingController textController = TextEditingController();
    RxString usd_value = '00.00'.obs;
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer(),
              Obx(() => Text("\$ ${usd_value.value}",
                  softWrap: true,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white))),
              // Spacer(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18, top: 20, bottom: 10),
            child: TextField(
              onChanged: (receiverAddress) =>
                  ref.setReceiverAddress(receiverAddress),
              decoration: InputDecoration(
                  fillColor: const Color(0xFF0F1212),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0F1212)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "Enter receiver's address",
                  suffixIcon: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.camera_alt))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18, top: 20, bottom: 10),
            child: TextField(
              controller: textController,
              onChanged: (amountToSend) {
                print("amiunt entered by the user:$amountToSend ");
                usd_value.value =
                    (double.parse(amountToSend) * usd_rate).toString();
                print(usd_value.value);
                print(usd_rate);
                ref.setTransactionValue(amountToSend);
              },
              decoration: InputDecoration(
                  fillColor: const Color(0xFF2C2C2C),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "Amount",
                  suffixIcon: Text(wallet.blockchain.ticker)),
            ),
          ),
          OutlinedButton(
              onPressed: () {
                textController.text = wallet.balance.toString();
                ref.setTransactionValue(wallet.balance);
              },
              child: const Text("MAX")),
          // Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child:
                ButtonBar(alignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel"),
                style: ElevatedButton.styleFrom(minimumSize: Size(150, 60)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SendStatus())),
                child: Text("Proceed"),
                style: ElevatedButton.styleFrom(minimumSize: Size(150, 60)),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class SendStatus extends ConsumerWidget {
  SendStatus({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(sendPod).when(
        data: (data) {
          return Container(
            child: Column(
              children: [
                Text("Successfully sent "),
                Text('receiver:${data['receiver']}'),
                Text('amount:${data['amount']}'),
                ButtonBar(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Box box = ref.watch(boxLoader.notifier).walletBox;
                          ref
                              .watch(sendCryptoProvider)
                              .refreshWalletBalances(box);
                          Navigator.of(context).pop();
                        },
                        child: Text("Ok"))
                  ],
                )
              ],
            ),
          );
        },
        error: (err, st) => const Center(child: Text("Failed to send")),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));
  }
}
