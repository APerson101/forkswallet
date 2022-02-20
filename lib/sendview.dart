import 'package:arbor/core/providers/send_crypto_provider.dart';
import 'package:arbor/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sendPod = FutureProvider((ref) async {
  final watcher = ref.watch(sendCryptoProvider);
  return watcher.send().then((value) {
    return watcher.sendCryptoStatus;
  });
});

class SendView extends ConsumerWidget {
  SendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchMan = ref.watch(sendCryptoProvider);
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0, left: 0, right: 0, child: getBar(context: context)),
          Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: getTextFields(context: context, ref: watchMan)),
        ],
      ),
    );
  }

  getBar({required BuildContext context}) {
    return ListTile(
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_new)),
      title: Text("Send XCH", style: Theme.of(context).textTheme.headline6),
      trailing: FlutterLogo(size: 24),
    );
  }

  getTextFields(
      {required BuildContext context, required SendCryptoProvider ref}) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer(),
              Text("\$00.00",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white)),
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
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0F1212)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  border: OutlineInputBorder(
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
              onChanged: (amountToSend) =>
                  ref.setTransactionValue(amountToSend),
              decoration: InputDecoration(
                  fillColor: const Color(0xFF2C2C2C),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "Amount",
                  suffixIcon: Text('xch')),
            ),
          ),
          OutlinedButton(onPressed: () {}, child: Text("MAX")),
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
                onPressed: () =>
                    MaterialPageRoute(builder: (context) => SendStatus()),
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
                Text("Succesffuly sent "),
                ButtonBar(
                  children: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Ok"))
                  ],
                )
              ],
            ),
          );
        },
        error: (err, st) => Center(child: Text("Failed to send")),
        loading: () => Center(child: CircularProgressIndicator.adaptive()));
  }
}
