import 'package:arbor/core/enums/supported_blockchains.dart';
import 'package:arbor/core/providers/restore_wallet_provider.dart';
import 'package:arbor/core/providers/send_crypto_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/constants/hive_constants.dart';
import 'core/providers/create_wallet_provider.dart';

class TestClass extends StatelessWidget {
  TestClass({Key? key}) : super(key: key);
  // late final Box walletBox = Hive.box(HiveConstants.walletBox);

  @override
  Widget build(BuildContext context) {
    return Consumer3<CreateWalletProvider, RestoreWalletProvider,
            SendCryptoProvider>(
        builder: (_, createmodel, recovermodel, sender, child) {
      return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () => {},
                  // createmodel.createNewWallet(coin: coin),
                  child: Text("create address")),
              // ElevatedButton(
              //     onPressed: () => model.createNewWallet(supported_forks.xch),
              //     child: Text("Transfer funds")),
              // ElevatedButton(
              //     onPressed: () => model.createNewWallet(supported_forks.xch),
              //     child: Text("view balance")),
              // ElevatedButton(
              //     onPressed: () => model.createNewWallet(supported_forks.xch),
              //     child: Text("view transactions")),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      onChanged: (newtext) =>
                          recovermodel.setFirstPassword(newtext),
                      decoration: InputDecoration())),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      onChanged: (newtext) =>
                          recovermodel.setSecondPassword(newtext),
                      decoration: InputDecoration())),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      onChanged: (newtext) =>
                          recovermodel.setThirdPassword(newtext),
                      decoration: InputDecoration())),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      onChanged: (newtext) =>
                          recovermodel.setFourthPassword(newtext),
                      decoration: InputDecoration())),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      onChanged: (newtext) =>
                          recovermodel.setFifthPassword(newtext),
                      decoration: InputDecoration())),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      onChanged: (newtext) =>
                          recovermodel.setSixthPassword(newtext),
                      decoration: InputDecoration())),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      onChanged: (newtext) =>
                          recovermodel.setSeventhPassword(newtext),
                      decoration: InputDecoration())),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      onChanged: (newtext) =>
                          recovermodel.setEighthPassword(newtext),
                      decoration: InputDecoration())),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      onChanged: (newtext) =>
                          recovermodel.setNinthPassword(newtext),
                      decoration: InputDecoration())),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      onChanged: (newtext) =>
                          recovermodel.setTenthPassword(newtext),
                      decoration: InputDecoration())),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      onChanged: (newtext) =>
                          recovermodel.setEleventhPassword(newtext),
                      decoration: InputDecoration())),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      onChanged: (newtext) =>
                          recovermodel.setTwelfthPassword(newtext),
                      decoration: const InputDecoration())),
              ElevatedButton(
                  onPressed: () {
                    recovermodel.concatenatePasswords();
                    recovermodel.recoverWallet();
                  },
                  child: Text("recover")),
              ElevatedButton(
                  onPressed: () {
                    // sender.getBalance(act);
                  },
                  child: Text("Get Balance")),
              ElevatedButton(
                  onPressed: () {
                    sender.send();
                  },
                  child: Text("send chia")),
            ],
          ),
        )),
      );
    });
  }
}
