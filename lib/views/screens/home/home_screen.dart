import 'package:arbor/api/services.dart';
import 'package:arbor/models/models.dart';
import 'package:arbor/views/screens/forks_selector/forks_dashboard_controller.dart';
import 'package:arbor/views/screens/send/value_screen.dart';
import 'package:arbor/views/screens/settings/settings_screen.dart';
import 'package:arbor/views/screens/home/wallet_receive_screen.dart';
import 'package:arbor/views/widgets/arbor_button.dart';
import 'package:arbor/views/widgets/dialogs/arbor_alert_dialog.dart';
import 'package:arbor/views/widgets/layout/arbor_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../core/constants/arbor_constants.dart';
import '../../../core/constants/hive_constants.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'expanded_home_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Box walletBox;

  // Pull to refresh wallet data
  Future<void> _reloadWalletBalances() async {
    WalletService walletService = WalletService();

    for (int index = 0; index < walletBox.length; index++) {
      Wallet existingWallet = walletBox.getAt(index);
      int newBalance = await walletService.fetchWalletBalance(existingWallet);

      Wallet newWallet = Wallet(
        name: existingWallet.name,
        phrase: existingWallet.phrase,
        privateKey: existingWallet.privateKey,
        publicKey: existingWallet.publicKey,
        address: existingWallet.address,
        blockchain: existingWallet.blockchain,
        balance: newBalance,
      );

      walletBox.putAt(index, newWallet);
    }
  }

  void _showReceiveView({required int walletIndex}) {
    Wallet walletData = walletBox.getAt(walletIndex) as Wallet;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalletReceiveScreen(
          index: walletIndex,
          wallet: walletData,
        ),
      ),
    );
  }

  void _setNotFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(ArborConstants.IS_FIRST_TIME_USER_KEY, false);
  }

  void _popupMenuItemSelected(String value, int walletBoxIndex) {
    switch (value) {
      case 'delete':
        {
          deleteWallet(walletBoxIndex);
          break;
        }
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    walletBox = Hive.box(HiveConstants.walletBox);

    // Since the user has seen this screen we assume they don't
    // need to see the Splash/On-Boarding views
    _setNotFirstTimeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.backgroundColor,
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Get.theme.backgroundColor,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: const Text(
              '',
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _reloadWalletBalances,
            strokeWidth: 2.5,
            child: ValueListenableBuilder(
              valueListenable: walletBox.listenable(),
              builder: (context, Box box, widget) {
                {
                  ForksDashboardController dash = Get.find();
                  var items = box.values.where((element) =>
                      element.blockchain.name == dash.selectedFork.value);
                  print({
                    'the number of items in this list is ',
                    dash.selectedFork.value
                  });
                  return ListView.builder(
                    padding: const EdgeInsets.only(
                        bottom: kFloatingActionButtonMargin + 60),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var currentBox = box;
                      var walletData = items.toList()[index];

                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ExpandedHomeScreen(
                              index: index,
                              wallet: walletData,
                            ),
                          ),
                        ),
                        child: Card(
                          // color: ArborColors.green,
                          elevation: 8,
                          // shadowColor: Colors.lightGreen,
                          margin: EdgeInsets.all(16),
                          child: Column(
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
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                title: Text(
                                  // '${walletData.fork.name} (${walletData.name})'
                                  '${walletData.blockchain.name}',
                                ),
                                subtitle: Text(
                                  walletData.blockchain.ticker.toUpperCase(),
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text('Delete'),
                                            ],
                                          ))
                                    ];
                                  },
                                  onSelected: (String value) {
                                    _popupMenuItemSelected(value, index);
                                  },
                                ),
                              ),
                              ListTile(
                                // title: Text(walletData.balance.toStringAsFixed(walletData.fork.precision)),
                                title: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      walletData.balanceForDisplay(),
                                    )),
                                subtitle: Text(
                                  walletData.address.toString(),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.all(
                                    10.0), //change for side padding
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: ArborButton(
                                      onPressed: () {
                                        _showReceiveView(walletIndex: index);
                                      },
                                      title: 'Receive',
                                      // backgroundColor: ArborColors.deepGreen,
                                    )),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: ArborButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ValueScreen(
                                                wallet: walletData,
                                              ),
                                            ),
                                          );
                                        },
                                        title: 'Send',
                                        // backgroundColor: ArborColors.deepGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          drawer: ArborDrawer(
            onWalletsTapped: () {},
            onSettingsTapped: () => Navigator.push(
              context,
              MaterialPageRoute<Widget>(
                builder: (context) => SettingsScreen(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Delete info from wallet box
  deleteWallet(int index) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ArborAlertDialog(
          title: "Delete Wallet",
          subTitle:
              "You cannot undo this action. Do you want to proceed to delete wallet?",
          onCancelPressed: () => Navigator.pop(context, false),
          onYesPressed: () => Navigator.pop(context, true),
        );
      },
    );
    if (result == true) {
      walletBox.deleteAt(index);
    }
  }
}
