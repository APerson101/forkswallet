import 'dart:convert';

import 'package:arbor/core/constants/arbor_constants.dart';
import 'package:arbor/core/providers/restore_wallet_provider.dart';
import 'package:arbor/core/providers/settings_provider.dart';
import 'package:arbor/models/models.dart';
import 'package:arbor/themes/theme_controller.dart';
import 'package:arbor/views/screens/base/base_screen.dart';
import 'package:arbor/views/screens/no_encryption_available_sccreen.dart';
import 'package:arbor/core/providers/send_crypto_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/hive_constants.dart';
import 'core/providers/create_wallet_provider.dart';
import 'models/blockchain.dart';
import 'models/transaction.dart';
import 'models/wallet.dart';
import 'views/screens/forks_selector/forks_dashboard_controller.dart';
import 'views/screens/on_boarding/splash_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  try {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var containsEncryptionKey = await secureStorage.containsKey(
        key: HiveConstants.hiveEncryptionKeyKey);
    if (!containsEncryptionKey) {
      var newEncryptionKey = Hive.generateSecureKey();
      await secureStorage.write(
          key: HiveConstants.hiveEncryptionKeyKey,
          value: base64UrlEncode(newEncryptionKey));
      await secureStorage.write(
          key: HiveConstants.hiveEncryptionSchemaKey, value: "1");
    }
    await secureStorage.readAll();

    String? keyFromSecureStorage =
        await secureStorage.read(key: HiveConstants.hiveEncryptionKeyKey);
    if (keyFromSecureStorage != null && keyFromSecureStorage != '') {
      var encryptionKey = base64Url.decode(keyFromSecureStorage);

      _hiveAdaptersRegistration();
      // Opening the box
      try {
        await Hive.openBox(HiveConstants.walletBox,
            encryptionCipher: HiveAesCipher(encryptionKey));
        await Hive.openBox(HiveConstants.transactionsBox,
            encryptionCipher: HiveAesCipher(encryptionKey));
      } on Exception catch (error) {
        return runApp(
          GetMaterialApp(
            theme: ThemeData.dark(),
            home: NoEncryptionAvailableScreen(
              message:
                  'We were unable to retrieve the encrypted keys to open your wallets. Please contact us.\n',
              errorString: 'Error: ${error.toString()}',
            ),
            debugShowCheckedModeBanner: false,
          ),
        );
      }

      runApp(MyApp());
    } else {
      return runApp(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: NoEncryptionAvailableScreen(
            message:
                'We were unable to retrieve the encrypted keys to open your wallets. Please contact us.',
            errorString: ' ',
          ),
          debugShowCheckedModeBanner: false,
        ),
      );
    }
  } catch (error) {
    return runApp(
      GetMaterialApp(
        theme: ThemeData.dark(),
        home: NoEncryptionAvailableScreen(
          message:
              'We were unable to use the encrypted storage for your wallets. Please contact us.\n',
          errorString: 'Error: ${error.toString()}',
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

void _hiveAdaptersRegistration() {
  Hive.registerAdapter(WalletAdapter());
  Hive.registerAdapter(BlockchainAdapter());
  Hive.registerAdapter(TransactionsGroupAdapter());
  //Hive.registerAdapter(TransactionGroupAdapter());
  Hive.registerAdapter(TransactionAdapter());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> _isFirstTimeUser() async {
    bool _isFirstTime;
    final prefs = await SharedPreferences.getInstance();
    _isFirstTime =
        (prefs.getBool(ArborConstants.IS_FIRST_TIME_USER_KEY) ?? true);
    return Future<bool>.value(_isFirstTime);
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    var status = prefs.getBool('theme');
    print({'the theme is ', status});
    var theme = status ?? false;
    return theme;
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreateWalletProvider()),
        ChangeNotifierProvider(create: (_) => RestoreWalletProvider()),
        ChangeNotifierProvider(create: (_) => SendCryptoProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: ScreenUtilInit(builder: () {
        return FutureBuilder<bool>(
            future: loadTheme(),
            builder: (context, theme) {
              var currTheme;
              if (theme.hasData) {
                currTheme = theme.data as bool;
                return GetMaterialApp(
                    title: 'Arbor',
                    initialBinding:
                        // BindingsBuilder(() => Get.lazyPut(() => ThemeController())),
                        BindingsBuilder(() {
                      Get.lazyPut(() => ForksDashboardController());
                      Get.lazyPut(() => ThemeController());
                    }),
                    theme: currTheme
                        ? ThemeData.dark()
                        : ThemeData(
                            brightness: Brightness.light,
                            primarySwatch: Colors.purple),
                    debugShowCheckedModeBanner: false,
                    home: FutureBuilder<bool>(
                        future: _isFirstTimeUser(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            bool _isFirstTime = snapshot.data as bool;
                            if (_isFirstTime) {
                              return SplashScreen();
                            } else {
                              return BaseScreen();
                            }
                          } else {
                            return Container(
                                // color: ArborColors.green,
                                );
                          }
                        }));
              }
              return Container();
            });
      }),
    );
  }
}
