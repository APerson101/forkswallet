import 'package:arbor/api/services.dart';
import 'package:arbor/core/enums/status.dart';
import 'package:arbor/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../hive_constants.dart';

class RestoreWalletProvider extends ChangeNotifier {
  Box box = Hive.box(HiveConstants.walletBox);
  CrossFadeState currentState = CrossFadeState.showFirst;
  Status recoverWalletStatus = Status.IDLE;
  QRViewController? controller;
  final walletService = WalletService();
  String bip39words = '';
  List<String> bipList = [];
  bool firstBatchButtonIsDisabled = false;
  bool secondBatchButtonIsDisabled = false;
  bool lastBatchButtonIsDisabled = false;
  RegExp passwordRegex = new RegExp(
    r"(?<![\w\d])abc(?![\w\d])",
    caseSensitive: false,
    multiLine: false,
  );

  String? firstPassword = '',
      secondPassword = '',
      thirdPassword = '',
      fourthPassword = '',
      fifthPassword = '',
      sixthPassword = '';
  String? seventhPassword = '',
      eighthPassword = '',
      ninthPassword = '',
      tenthPassword = '',
      eleventhPassword = '',
      twelfthPassword = '';

  String errorMessage1 = '',
      errorMessage2 = '',
      errorMessage3 = '',
      errorMessage4 = '',
      errorMessage5 = '',
      errorMessage6 = '',
      errorMessage7 = '',
      errorMessage8 = '',
      errorMessage9 = '',
      errorMessage10 = '',
      errorMessage11 = '',
      errorMessage12 = '';

  bool _password1IsCorrect = false,
      _password2IsCorrect = false,
      _password3IsCorrect = false,
      _password4IsCorrect = false,
      _password5IsCorrect = false,
      _password6IsCorrect = false,
      _password7IsCorrect = false,
      _password8IsCorrect = false,
      _password9IsCorrect = false,
      _password10IsCorrect = false,
      _password11IsCorrect = false,
      _password12IsCorrect = false;

  String _errorMessage = 'Invalid password';

  Wallet? recoveredWallet;
  String allPassword = '';

  bool validatePassword(String word) {
    try {
      if (word.length >= 3 && (word == bipList.firstWhere((e) => e == word))) {
        return true;
      } else {
        return false;
      }
    } on StateError catch (e) {
      debugPrint('ERROR: ${e.toString()}');
      return false;
    } on Exception catch (e) {
      debugPrint('ERROR: ${e.toString()}');
      return false;
    }
  }

  setFirstPassword(String password) {
    firstPassword = password;
    if (validatePassword(password)) {
      errorMessage1 = '';
      _password1IsCorrect = true;
    } else {
      errorMessage1 = _errorMessage;
    }
    notifyListeners();
  }

  setSecondPassword(String password) {
    secondPassword = password;
    if (validatePassword(password)) {
      errorMessage2 = '';
    } else {
      errorMessage2 = _errorMessage;
    }
    notifyListeners();
  }

  setThirdPassword(String password) {
    thirdPassword = password;
    if (validatePassword(password)) {
      errorMessage3 = '';
    } else {
      errorMessage3 = _errorMessage;
    }
    notifyListeners();
  }

  setFourthPassword(String password) {
    fourthPassword = password;
    if (validatePassword(password)) {
      errorMessage4 = '';
    } else {
      errorMessage4 = _errorMessage;
    }
    notifyListeners();
  }

  setFifthPassword(String password) {
    fifthPassword = password;
    if (validatePassword(password)) {
      errorMessage5 = '';
    } else {
      errorMessage5 = _errorMessage;
    }
    notifyListeners();
  }

  setSixthPassword(String password) {
    sixthPassword = password;
    if (validatePassword(password)) {
      errorMessage6 = '';
    } else {
      errorMessage6 = _errorMessage;
    }
    notifyListeners();
  }

  setSeventhPassword(String password) {
    seventhPassword = password;
    if (validatePassword(password)) {
      errorMessage7 = '';
    } else {
      errorMessage7 = _errorMessage;
    }
    notifyListeners();
  }

  setEighthPassword(String password) {
    eighthPassword = password;
    if (validatePassword(password)) {
      errorMessage8 = '';
    } else {
      errorMessage8 = _errorMessage;
    }
    notifyListeners();
  }

  setNinthPassword(String password) {
    ninthPassword = password;
    if (validatePassword(password)) {
      errorMessage9 = '';
    } else {
      errorMessage9 = _errorMessage;
    }
    notifyListeners();
  }

  setTenthPassword(String password) {
    tenthPassword = password;
    if (validatePassword(password)) {
      errorMessage10 = '';
    } else {
      errorMessage10 = _errorMessage;
    }
    notifyListeners();
  }

  setEleventhPassword(String password) {
    eleventhPassword = password;
    if (validatePassword(password)) {
      errorMessage11 = '';
    } else {
      errorMessage11 = _errorMessage;
    }
    notifyListeners();
  }

  setTwelfthPassword(String password) {
    twelfthPassword = password;
    if (validatePassword(password)) {
      errorMessage12 = '';
    } else {
      errorMessage12 = _errorMessage;
    }
    notifyListeners();
  }

  concatenatePasswords() {
    allPassword =
        '${firstPassword!.trim()} ${secondPassword!.trim()} ${thirdPassword!.trim()} ${fourthPassword!.trim()} '
        '${fifthPassword!.trim()} ${sixthPassword!.trim()} ${seventhPassword!.trim()} ${eighthPassword!.trim()} '
        '${ninthPassword!.trim()} ${tenthPassword!.trim()} ${eleventhPassword!.trim()} ${twelfthPassword!.trim()}';
  }

  bool validateFirstBatch() {
    if (_password1IsCorrect == false ||
        _password2IsCorrect == false ||
        _password3IsCorrect == false ||
        _password4IsCorrect == false) {
      if (_password1IsCorrect == false) {
        errorMessage1 = _errorMessage;
      }

      if (_password2IsCorrect == false) {
        errorMessage2 = _errorMessage;
      }

      if (_password3IsCorrect == false) {
        errorMessage3 = _errorMessage;
      }

      if (_password4IsCorrect == false) {
        errorMessage4 = _errorMessage;
      }
      notifyListeners();
      return false;
    } else {
      return true;
    }
  }

  bool validateSecondBatch() {
    if (_password5IsCorrect == false ||
        _password6IsCorrect == false ||
        _password7IsCorrect == false ||
        _password8IsCorrect == false) {
      if (_password5IsCorrect == false) {
        errorMessage5 = _errorMessage;
      }

      if (_password6IsCorrect == false) {
        errorMessage6 = _errorMessage;
      }

      if (_password7IsCorrect == false) {
        errorMessage7 = _errorMessage;
      }

      if (_password8IsCorrect == false) {
        errorMessage8 = _errorMessage;
      }
      notifyListeners();
      return false;
    } else {
      return true;
    }
  }

  bool validateLastBatch() {
    if (_password9IsCorrect == false ||
        _password10IsCorrect == false ||
        _password11IsCorrect == false ||
        _password12IsCorrect == false) {
      if (_password9IsCorrect == false) {
        errorMessage9 = _errorMessage;
      }

      if (_password10IsCorrect == false) {
        errorMessage10 = _errorMessage;
      }

      if (_password11IsCorrect == false) {
        errorMessage11 = _errorMessage;
      }

      if (_password12IsCorrect == false) {
        errorMessage12 = _errorMessage;
      }
      notifyListeners();
      return false;
    } else {
      return true;
    }
  }

  clearErrorMessages() {
    errorMessage1 = '';
    errorMessage2 = '';
    errorMessage3 = '';
    errorMessage4 = '';
    errorMessage5 = '';
    errorMessage6 = '';
    errorMessage7 = '';
    errorMessage8 = '';
    errorMessage9 = '';
    errorMessage10 = '';
    errorMessage11 = '';
    errorMessage12 = '';
  }

  void nextScreen() {
    if (currentState == CrossFadeState.showFirst) {
      currentState = CrossFadeState.showSecond;
      notifyListeners();
    } else {}
  }

  back() {
    currentState = CrossFadeState.showFirst;
    notifyListeners();
  }

  void onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      allPassword = scanData.code;
      recoverWallet();
    });
  }

  recoverWallet() async {
    recoverWalletStatus = Status.LOADING;
    notifyListeners();
    try {
      recoveredWallet = await walletService.recoverWallet(
        '$allPassword',
      );
      print('${recoveredWallet.toString()}');
      box.add(recoveredWallet);
    } on Exception catch (e) {
      print('Error');
      recoverWalletStatus = Status.ERROR;
      notifyListeners();
      throw Exception('${e.toString()}');
    }
    recoverWalletStatus = Status.SUCCESS;
    notifyListeners();
  }

  clearStatus() {
    recoverWalletStatus = Status.IDLE;
  }

  setBip39Words() async {
    try {
      bip39words = await loadAsset();
      bipList = bip39words.trim().split('\n').map((e) => e).toList();
      print(bip39words.length);
      print('LIST: ${bipList.length}');
      recoverWalletStatus = Status.SUCCESS;
      notifyListeners();
    } on Exception catch (e) {
      debugPrint('ERROR: ${e.toString()}');
    }
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/bip39/english.txt');
  }
}
