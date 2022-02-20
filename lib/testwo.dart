import 'package:arbor/addressdetails.dart';
import 'package:arbor/importwallet.dart';
import 'package:arbor/sendview.dart';
import 'package:arbor/walletselector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:styled_widget/styled_widget.dart';

import 'createwalletview.dart';

class TestTwo extends StatelessWidget {
  const TestTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            DrawerHeader(
                child: FlutterLogo(
              size: 24,
            )),
            ListTile(
                onTap: () {},
                leading: Icon(Icons.settings),
                title: Text("Settings")),
            ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateWalletView())),
                leading: Icon(Icons.new_label),
                title: Text("Create Wallet")),
            ListTile(
                onTap: () => Get.to(() => ImportWalletView()),
                leading: Icon(Icons.new_label),
                title: Text("Import Wallet")),
          ],
        )),
        body: MainBody());
  }
}

class MainBody extends StatelessWidget {
  const MainBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF737874),
              Color(0xFF393939),
            ]),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Positioned.directional(
                  textDirection: TextDirection.ltr,
                  top: 5,
                  start: 0,
                  end: 0,
                  height: 25,
                  child: topBar(context)),
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Column(children: getChildren(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getChildren(BuildContext context) {
    List<Widget> children = [];
    children.add(getBalance(context));
    children.add(SizedBox(height: 40));
    children.add(DefaultTabController(
        length: 2,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: Column(
            children: [
              TabBar(tabs: [
                Tab(
                  text: 'Assets',
                ),
                Tab(
                  text: 'History',
                ),
              ]),
              Expanded(
                child: TabBarView(children: [
                  Container(
                    child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 20),
                        child: getCoinDetails()),
                  ),
                  Container(
                    child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 20),
                        child: ListView(children: getTxns(context: context))),
                  ),
                ]),
              )
            ],
          ),
        )));
    // children.add(getCoinDetails());
    return children;
  }

  getBalance(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("\$19,018.474",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          ButtonBar(
            buttonMinWidth: double.infinity,
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => Get.to(() => SendView()),
                  child: Text("Send"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), minimumSize: Size(150, 60))),
              ElevatedButton(
                  onPressed: () async => await Get.defaultDialog(
                      title: "Your wallet address",
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width - 10,
                        height: MediaQuery.of(context).size.height - 150,
                        child: Column(children: [
                          Row(children: [
                            Spacer(),
                            Text('xch0xfds...45jkds',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            IconButton(
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: 'stuffs'));
                                  Get.snackbar(
                                      'status', "address copied to clipbord",
                                      duration: Duration(seconds: 1));
                                },
                                icon: Icon(
                                  Icons.copy,
                                  color: Colors.grey,
                                )),
                            Spacer()
                          ]),
                          SizedBox(
                            height: 15,
                          ),
                          QrImage(
                            data: "stuffs",
                            size: 250,
                            version: QrVersions.auto,
                          )
                        ]),
                      )),
                  child: Text("Receive"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), minimumSize: Size(150, 60))),
            ],
          )
        ],
      ),
    );
  }

  Widget topBar(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(
          onPressed: () {
            !Scaffold.of(context).isDrawerOpen
                ? Scaffold.of(context).openDrawer()
                : Navigator.pop(context);
          },
          icon: Scaffold.of(context).isDrawerOpen
              ? Icon(Icons.cancel)
              : Icon(Icons.menu)),
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTap: () => Get.to(() => WalletSelector()),
            child: Row(children: [
              RichText(
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  text: TextSpan(
                      text: "Chia 1",
                      style: Theme.of(context).textTheme.subtitle1,
                      children: [
                        TextSpan(
                            text: "(xch34f4...99f4)",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.grey))
                      ])),
              Icon(Icons.arrow_drop_down_outlined)
            ])),
      ),
      IconButton(
          onPressed: () {
            //show address details
            Get.to(() => AddressDetails());
          },
          icon: Icon(Icons.dashboard))
    ]);
  }

  getCoinDetails() {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: ListTile(
        onTap: () {},
        leading: FlutterLogo(size: 24),
        title: Text("Solana",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white)),
        subtitle: Text(
          "110 SOL",
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Text("\$16,560.5",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white)),
      ),
    );
  }

  List<Widget> getTxns({required BuildContext context}) {
    List<Card> txns = [];
    var dd = Card(
        child: ListTile(
      onTap: () async => await Get.defaultDialog(
          content: SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        height: MediaQuery.of(context).size.height - 100,
        child: Column(children: [
          Text("Block number"),
          Text("Receiver full details"),
          Text("Txn ID"),
          Text("Some hash stuffs probably"),
        ]),
      )),
      leading: Icon(Icons.send),
      title: Text("Receiver: xch458hi43498hkjdhg4"),
      subtitle: RichText(
        text: TextSpan(
            text: "status",
            style: Theme.of(context).textTheme.subtitle1,
            children: [TextSpan(text: "pending")]),
      ),
      trailing: Text("\$546"),
    ));
    txns.add(dd);
    txns.add(dd);
    txns.add(dd);
    return txns;
  }
}
