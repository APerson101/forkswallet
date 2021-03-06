import 'package:arbor/api/services.dart';
import 'package:arbor/core/constants/hive_constants.dart';
import 'package:arbor/core/enums/status.dart';
import 'package:arbor/core/enums/supported_blockchains.dart';
import 'package:arbor/core/models/phrase.dart';
import 'package:arbor/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class CreateWalletProvider {
  Box box = Hive.box(HiveConstants.walletBox);
  Status createWalletStatus = Status.IDLE;
  final walletService = WalletService();
  Wallet? newWallet;
  String seedPhrase = '';

  List<String> _wordsList = [];

  List<Phrase> _phrasesList = [];
  List<Phrase> get phrasesList => _phrasesList;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _revealPhrase = false;
  bool get revealPhrase => _revealPhrase;

  String _appBarTitle = '';
  String get appBarTitle => _appBarTitle;

  String _revealButtonTitle = 'Reveal the Phrase';
  String get revealButtonTitle => _revealButtonTitle;

  setRevealPhrase() {
    if (_tappedRevealButton == false) {
      _tappedRevealButton = true;
    }
    _revealPhrase = !_revealPhrase;
    if (_revealPhrase == true) {
      _revealButtonTitle = 'Hide the Phrase';
    } else {
      _revealButtonTitle = 'Reveal the Phrase';
    }
    // notifyListeners();
  }

  bool _tappedRevealButton = false;
  bool get tappedRevealButton => _tappedRevealButton;

  createNewWallet({required supported_forks coin}) async {
    // createWalletStatus = Status.LOADING;
    // _appBarTitle = 'Generating';
    // notifyListeners();
    var wtch = Stopwatch();
    wtch.start();
    // await compute(walletService.createNewWallet, supported_forks.xch);
    print({'iiss', wtch.elapsed});

    try {
      newWallet = await compute(walletService.createNewWallet, coin);
      seedPhrase = newWallet!.phrase;
      _wordsList = seedPhrase.split(' ').toList();

      for (int i = 0; i < _wordsList.length; i++) {
        _phrasesList.add(Phrase(index: i, phrase: _wordsList[i]));
      }

      box.add(newWallet);
      return newWallet;
    } on Exception catch (e) {
      debugPrint('Create Wallet Error: ${e.toString()} ${e.runtimeType}');

      _errorMessage = e.toString();

      _appBarTitle = 'Error';
      createWalletStatus = Status.ERROR;
      // notifyListeners();
    }
    // _appBarTitle = 'Secret Phrase';
    // createWalletStatus = Status.SUCCESS;
    // notifyListeners();
    // return _phrasesList;
  }

  clearAll() {
    _wordsList = [];
    _phrasesList = [];
    _appBarTitle = 'Generating';
    _revealButtonTitle = 'Reveal the Phrase';
    createWalletStatus = Status.IDLE;
    _revealPhrase = false;
    _tappedRevealButton = false;
    // notifyListeners();
  }
}
