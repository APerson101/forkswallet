import 'package:arbor/core/providers/restore_wallet_provider.dart';
import 'package:arbor/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final restorePod = FutureProvider((ref) async {
  final watcher = ref.watch(restoreWalletProvider);
  await watcher.recoverWallet();
  return watcher;
});

class ImportWalletView extends ConsumerWidget {
  ImportWalletView({Key? key}) : super(key: key);

  RxString keyPhrase = ''.obs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        )),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            "Import Wallet",
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
              "To import already existing wallet, enter your 12-word secret in the field below, use single spacebar to separate each word"),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 350,
              child: TextField(
                // inputFormatters: [PhrasesText()],
                onChanged: (text) {
                  keyPhrase.value = text;
                },
                decoration:
                    const InputDecoration(hintText: 'abcd efgh ijkl mnop'),
              )),
          ButtonBar(
            buttonMinWidth: double.infinity,
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), minimumSize: Size(150, 60))),
              Obx(() {
                bool val = keyPhrase.value.isEmpty;
                return ElevatedButton(
                    onPressed: () async {
                      MaterialPageRoute(builder: (contex) => StatusScreen());
                      // provider.concatenatePasswords();
                      // provider.recoverWallet(string: keyPhrase.value);
                    },
                    child: Text("Continue"),
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(), minimumSize: Size(150, 60)));
              }),
            ],
          )
        ]));
  }
}

class StatusScreen extends ConsumerWidget {
  StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(restorePod).when(
        data: (data) {
          //wallet added success page
          return Column(
            children: [
              Text("Wallet added successfully"),
              Text(data.recoveredWallet!.address),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("proceed"))
            ],
          );
        },
        error: (err, st) => const Center(child: Text("Failed to Load")),
        loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ));
  }
}

class PhrasesText extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    StringBuffer displayText = StringBuffer();
    for (var char in newValue.text.characters) {
      print(char);
      if (char == " ") displayText..write(" ");
      displayText..write(char);
    }
    print(displayText.toString());
    print({'old val', oldValue.text});
    print({'new val', newValue.text});
    return TextEditingValue(text: displayText.toString());
  }
}
