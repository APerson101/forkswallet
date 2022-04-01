import 'dart:typed_data';

import 'package:arbor/bls/ec.dart';
import 'package:arbor/bls/private_key.dart';
import 'package:arbor/clvm/program.dart';
import 'package:arbor/core/utils/wallet_utils.dart';
import 'package:bech32m/bech32m.dart';
import 'package:bip39/bip39.dart';
import 'package:flutter/foundation.dart';
import 'package:hex/hex.dart';

class LocalSigner {
  String generateWalletMnemonic() {
    String mnemonic = generateMnemonic();
    return mnemonic;
  }

  WalletKeysAndAddress convertMnemonicToKeysAndAddress(Map map) {
    var wtch = Stopwatch();
    wtch.start();
    var seed = mnemonicToSeed(map['mnemonic']);
    print(wtch.elapsed);
    var privateKey = PrivateKey.fromSeed(seed);
    print(wtch.elapsed);

    var publicKey = privateKey.getG1();
    print(wtch.elapsed);

    var puzzle = walletPuzzle.curry([Program.atom(publicKey.toBytes())]);
    print(wtch.elapsed);

    var puzzleHash = puzzle.hash();
    print(wtch.elapsed);

    var address = segwit.encode(Segwit(map['ticker'], puzzleHash));
    print(wtch.elapsed);
    wtch.stop();
    return WalletKeysAndAddress(address, privateKey, publicKey);
  }

  SignedTransactionResponse usePrivateKeyToGenerateHash(
      String privateKey, String ticker) {
    var privateKeyObject = PrivateKey.fromBytes(
        Uint8List.fromList(const HexDecoder().convert(privateKey)));
    var publicKeyObject = privateKeyObject.getG1();
    var wallet = walletPuzzle.curry([Program.atom(publicKeyObject.toBytes())]);
    var puzzleHash = wallet.hash();
    var address = segwit.encode(Segwit(ticker, puzzleHash));

    return SignedTransactionResponse(
        wallet, privateKeyObject, puzzleHash, address);
  }
}

class WalletKeysAndAddress {
  final String address;
  final PrivateKey privateKey;
  final JacobianPoint publicKey;

  WalletKeysAndAddress(this.address, this.privateKey, this.publicKey);
}

class SignedTransactionResponse {
  Program wallet;
  PrivateKey privateKeyObject;
  Uint8List puzzleHash;
  String address;

  SignedTransactionResponse(
      this.wallet, this.privateKeyObject, this.puzzleHash, this.address);
}
