import 'package:arbor/core/constants/arbor_constants.dart';
import 'package:arbor/models/models.dart';
import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/views/screens/send/value_screen.dart';
import 'package:arbor/views/screens/home/transactions_screen.dart';
import 'package:arbor/views/widgets/arbor_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter/services.dart';
import 'package:arbor/views/screens/home/wallet_receive_screen.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/constants/hive_constants.dart';

class ExpandedHomePage extends StatefulWidget {
  const ExpandedHomePage({
    required this.index,
    required this.wallet,
  });

  final int index;
  final Wallet wallet;

  @override
  _ExpandedHomePageState createState() => _ExpandedHomePageState();
}

class _ExpandedHomePageState extends State<ExpandedHomePage> {
  late final Box walletBox;

  int get index => widget.index;

  void _showReceiveView() {
    Wallet walletData = walletBox.getAt(index) as Wallet;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalletReceiveScreen(
          index: index,
          wallet: walletData,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    walletBox = Hive.box(HiveConstants.walletBox);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ValueListenableBuilder(
        valueListenable: walletBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                  'Hmm... We could not find a wallet to show. Please try again'),
            );
          } else {
            var walletData = walletBox.getAt(index);
            return Column(
              children: [
                ListTile(
                  leading: Container(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        ArborConstants.baseWebsiteURL +
                            walletData.blockchain.logo,
                        fit: BoxFit.contain,
                        height: 50,
                        width: 50,
                      ).decorated(
                          shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(20))),
                  // title: Text('${walletData.fork.name} (${walletData.name})'),
                  title: Text(
                    '${walletData.blockchain.name}',
                  ),
                  subtitle: Text(
                    walletData.blockchain.ticker.toUpperCase(),
                    style: TextStyle(
                      color: ArborColors.white70,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        '${walletData.blockchain.ticker.toUpperCase()}: ${walletData.balanceForDisplay()}',
                      ),
                    ),
                    trailing: Icon(Icons.copy),
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: walletData.balanceForDisplay()));
                      showSnackBar(context, 'Balance copied');
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      'Address',
                    ),
                    subtitle: Text(
                      walletData.address,
                    ),
                    trailing: Icon(Icons.copy),
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: walletData.address));
                      showSnackBar(context, 'Wallet address copied');
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      'Public Key',
                    ),
                    subtitle: Text(
                      walletData.publicKey,
                    ),
                    trailing: Icon(Icons.copy),
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: walletData.publicKey));
                      showSnackBar(context, 'Public key copied');
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      'Private Key',
                    ),
                    subtitle: Text(
                      '*' * walletData.privateKey.toString().length,
                    ),
                    trailing: Icon(Icons.copy),
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: walletData.privateKey));
                      showSnackBar(context, 'Private key copied');
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      SizedBox(
        height: 40,
      ),
      ArborButton(
        // style: ElevatedButton.styleFrom(
        //   minimumSize: Size(double.infinity,
        //       30), // double.infinity is the width and 30 is the height
        // ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return TransactionsSheet(
                walletAddress: (walletBox.getAt(index) as Wallet).address,
                precision: widget.wallet.blockchain.precision,
              );
            },
          );
        },
        title: 'All Transactions',
      ),
      ListTile(
        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        title: Row(
          children: <Widget>[
            Expanded(
                child: ArborButton(
                    onPressed: () {
                      _showReceiveView();
                    },
                    title: 'Receive')),
            SizedBox(width: 10),
            Expanded(
                child: ArborButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ValueScreen(
                            wallet: widget.wallet,
                          ),
                        ),
                      );
                    },
                    title: 'Send')),
          ],
        ),
      )
    ]);
  }

  showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$message!"),
        duration: Duration(milliseconds: 1000),
        elevation: 2,
        padding: EdgeInsets.all(
          10,
        ), // Inner padding for SnackBar content.
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
