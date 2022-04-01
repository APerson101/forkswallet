import 'package:arbor/core/providers/restore_wallet_provider.dart';
import 'package:arbor/main.dart';
import 'package:arbor/testwo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/wallet.dart';

final restorePod = FutureProvider((ref) async {
  final watcher = ref.watch(restoreWalletProvider).recoverWallet();
  // final Wallet stuff = await watcher.recoverWallet().then((value) => value);
  return watcher;
});

class ImportWalletView extends ConsumerWidget {
  final String previousPage;
  ImportWalletView({Key? key, required this.previousPage}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchman = ref.watch(restoreWalletProvider);
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                  watchman.words = text;
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
              ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StatusScreen(
                                  previousPage: previousPage,
                                )));
                    // provider.concatenatePasswords();
                    // provider.recoverWallet(string: keyPhrase.value);
                  },
                  child: const Text("Continue"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), minimumSize: Size(150, 60)))
            ],
          )
        ]));
  }
}

class StatusScreen extends ConsumerWidget {
  String previousPage;
  StatusScreen({Key? key, required this.previousPage}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(restorePod).when(
        data: (data) {
          //wallet added success page
          ref.watch(boxLoader.notifier).setCurrentWallet(data, -1);
          return Scaffold(
              body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Wallet added successfully"),
              Text("Address: ${data.address}"),
              ElevatedButton(
                  onPressed: () async {
                    previousPage == 'splash'
                        ? Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TestTwo(previousPage: previousPage)))
                        : Navigator.of(context).pop();
                  },
                  child: const Text("proceed"))
            ],
          ));
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
