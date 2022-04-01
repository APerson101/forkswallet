import 'package:arbor/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddressDetails extends StatelessWidget {
  AddressDetails({Key? key, required this.wallet}) : super(key: key);
  Wallet wallet;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back_ios_new)),
            title: Text("Address details",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold)),
          ),
        ),
        Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(
                          ClipboardData(text: wallet.privateKey));
                      Get.snackbar('copied', 'privatekey copied to clipbord');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: RichText(
                            text: TextSpan(
                                text: "Private key: ",
                                style: Theme.of(context).textTheme.headline6,
                                children: [
                              TextSpan(text: "${wallet.privateKey}")
                            ])),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(
                            ClipboardData(text: wallet.publicKey));
                        Get.snackbar('copied', 'publicKey copied to clipbord');
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              child: RichText(
                                  text: TextSpan(
                                      text: "Public key: ",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                      children: [
                                TextSpan(text: "${wallet.publicKey}")
                              ]))))),
                  GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(
                            ClipboardData(text: wallet.address));
                        Get.snackbar('copied', 'Address copied to clipbord');
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              child: RichText(
                                  text: TextSpan(
                                      text: "Address: ",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                      children: [
                                TextSpan(text: "${wallet.address}")
                              ]))))),
                ]))
      ],
    ));
  }
}
