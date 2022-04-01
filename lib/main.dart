import 'dart:convert';

import 'package:arbor/core/providers/restore_wallet_provider.dart';
import 'package:arbor/core/providers/settings_provider.dart';
import 'package:arbor/models/models.dart';
import 'package:arbor/core/providers/restore_wallet_provider.dart';
import 'package:arbor/core/providers/settings_provider.dart';
import 'package:arbor/models/models.dart';
import 'package:arbor/views/screens/no_encryption_available_sccreen.dart';
import 'package:arbor/core/providers/send_crypto_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/constants/hive_constants.dart';
import 'core/providers/create_wallet_provider.dart';
import 'models/transaction.dart';
import 'testwo.dart';
import 'testwo.dart';
import 'models/wallet.dart';
import 'views/screens/forks_selector/forks_dashboard_controller.dart';
import 'views/screens/on_boarding/splash_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(ProviderScope(child: MyApp()));
  await Hive.initFlutter();
  // return;

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
      runApp(ProviderScope(child: MyApp()));
    } else {
      return runApp(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const NoEncryptionAvailableScreen(
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

final createWalletProvider = Provider((ref) => CreateWalletProvider());
final restoreWalletProvider = Provider((ref) => RestoreWalletProvider());
final sendCryptoProvider = Provider((ref) => SendCryptoProvider());
final settingsProvider = Provider((ref) => SettingsProvider());
final allWalletsController = Provider((rf) => ForksController());

void _hiveAdaptersRegistration() {
  Hive.registerAdapter(WalletAdapter());
  Hive.registerAdapter(BlockchainAdapter());
  Hive.registerAdapter(TransactionsGroupAdapter());
  Hive.registerAdapter(TransactionAdapter());
}

class MyApp extends ConsumerWidget {
  final firstTimeUser =
      FutureProvider((ref) => Hive.box(HiveConstants.walletBox).length > 0);

  // Future<bool> _isFirstTimeUser() async {
  //   bool _isFirstTime;
  //   // final prefs = await SharedPreferences.getInstance();
  //   _isFirstTime = Hive.box(HiveConstants.walletBox).length > 0;

  //   // _isFirstTime =
  //   //     (prefs.getBool(ArborConstants.IS_FIRST_TIME_USER_KEY) ?? true);

  //   print({'new user status is : ', _isFirstTime});
  //   return Future<bool>.value(_isFirstTime);
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(builder: () {
      return GetMaterialApp(
          theme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          home: ref.watch(firstTimeUser).when(
            data: (status) {
              if (status) {
                print('status of new user: $status');
                return TestTwo(
                  previousPage: 'main',
                );
              } else {
                print('Status has changed');

                return SplashScreen();
              }
            },
            error: (Object error, StackTrace? stackTrace) {
              return Center(
                child: Text(stackTrace.toString()),
              );
            },
            loading: () {
              print("loaidng");
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            },
          ));
      // return GetMaterialApp(
      //     theme: ThemeData.dark(),
      //     debugShowCheckedModeBanner: false,
      //     home: FutureBuilder<bool>(
      //         future: _isFirstTimeUser(),
      //         builder: (context, snapshot) {
      //           if (snapshot.hasData) {
      //             bool _isFirstTime = snapshot.data as bool;
      //             if (!_isFirstTime) {
      //               // return TestTwo();

      //               return SplashScreen();
      //             } else {
      //               // return BaseScreen();
      //             }
      //           } else {
      //             return Container(
      //                 // color: ArborColors.green,
      //                 );
      //           }
      //         }));
    });
  }
}
