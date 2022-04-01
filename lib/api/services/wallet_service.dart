import 'dart:core';
import 'dart:typed_data';
import 'package:arbor/api/responses/coin_response.dart';
// import 'package:arbor/api/responses/record_response.dart';
// import 'package:arbor/api/responses/records_response.dart';
import 'package:arbor/api/responses/transaction_response.dart';
import 'package:arbor/api/responses/utxos.dart';
// import 'package:arbor/api/responses/wallet_address_response.dart';
import 'package:arbor/bls/ec.dart';
import 'package:arbor/bls/schemes.dart';
import 'package:arbor/clvm/program.dart';
import 'package:arbor/core/enums/supported_blockchains.dart';
import 'package:arbor/core/utils/local_signer.dart';
import 'package:arbor/models/transaction.dart';
import 'package:arbor/models/usdvalue.dart';
import 'package:bech32m/bech32m.dart';
import 'package:flutter/foundation.dart';
import 'package:hex/hex.dart';
import '/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../responses.dart';
import 'api_service.dart';

class WalletService extends ApiService {
  WalletService({this.baseURL = ApiService.baseURL});

  final String baseURL;

  BaseResponse? baseResponse;

  Wallet createNewWallet(supported_forks fork) {
    String mnemonic = "";
    WalletKeysAndAddress? keyAddress;
    LocalSigner localSigner = LocalSigner();

    try {
      mnemonic = localSigner.generateWalletMnemonic();
      print(mnemonic);
      // return Future.delayed(Duration(seconds: 10), () => 'done');
      var wtch = Stopwatch();
      wtch.start();
      keyAddress = localSigner.convertMnemonicToKeysAndAddress(
          {'mnemonic': mnemonic, 'ticker': describeEnum(fork)});
      print({'wait time', wtch.elapsed});
      print({'address', keyAddress.address});
      print({
        'public key',
        const HexEncoder().convert(keyAddress.publicKey.toBytes())
      });
      print({
        'private key',
        const HexEncoder().convert(keyAddress.privateKey.toBytes())
      });
    } on Exception catch (e) {
      throw Exception('ERROR : ${e.toString()}');
    }

    // Blockchain? blockchain = await fetchBlockchainInfo();
    Blockchain blockchain;
    switch (fork) {
      case supported_forks.xch:
        blockchain = Blockchain(
            name: 'Chia',
            unit: 'Mojo',
            logo: '/icons/blockchains/chia.png',
            ticker: 'xch',
            precision: 12,
            network_fee: 0);
        break;
      case supported_forks.hdd:
        blockchain = Blockchain(
            name: 'HDD',
            ticker: 'hdd',
            unit: 'Mojo',
            precision: 12,
            logo: 'logo',
            network_fee: 0);
        break;
      case supported_forks.xcd:
        blockchain = Blockchain(
            name: 'ChiaDoge',
            ticker: 'xcd',
            unit: 'Mojo',
            precision: 12,
            logo: 'logo',
            network_fee: 0);
        break;
      default:
        blockchain = Blockchain(
            name: 'name',
            ticker: 'ticker',
            unit: 'unit',
            precision: 12,
            logo: 'logo',
            network_fee: 0);
        break;
    }

//agg_sig_me_extra_data: ccd5bb71183532bff220ba46c268991a3ff07eb358e8255a65c30a2dce0e5fbb,
// blockchain_fee: 0
    Wallet wallet = Wallet(
      name: '',
      phrase: mnemonic,
      privateKey: const HexEncoder().convert(keyAddress.privateKey.toBytes()),
      publicKey: const HexEncoder().convert(keyAddress.publicKey.toBytes()),
      address: keyAddress.address,
      blockchain: blockchain,
      balance: 0,
    );
    return wallet;
    // return wallet;
  }

  recoverWallet(String phrase, supported_forks ticker) async {
    WalletKeysAndAddress? keyAddress;
    print(phrase);
    var hrase =
        'rain return actual brand story health twice width perfect gossip cinnamon infant';
    try {
      LocalSigner localSigner = LocalSigner();

      keyAddress = await compute(localSigner.convertMnemonicToKeysAndAddress,
          {'mnemonic': phrase, 'ticker': describeEnum(ticker)});
    } on Exception catch (e) {
      throw Exception('ERROR : ${e.toString()}');
    }
    print(keyAddress!.address);
    String address = keyAddress!.address;
    try {
      final balanceResponse = await http.get(
        Uri.parse(
            'http://162.213.248.37:8081/v1/blockchain/${describeEnum(ticker)}/address/$address/balance'),
      );
      if (balanceResponse.statusCode == 200) {
        print("balance recovery success");
        BalanceResponse balance = BalanceResponse.fromJson(
            jsonDecode(balanceResponse.body)["result"]);
        // Blockchain? blockchain = await fetchBlockchainInfo();
        Blockchain blockchain;
        var ss = describeEnum(supported_forks.xch);
        switch (ticker) {
          case supported_forks.xch:
            blockchain = Blockchain(
                name: 'Chia',
                unit: 'Mojo',
                logo: '/icons/blockchains/chia.png',
                ticker: 'xch',
                precision: 12,
                network_fee: 0);
            break;
          case supported_forks.hdd:
            blockchain = Blockchain(
                name: 'HDD',
                unit: ' ',
                logo: '/icons/blockchains/chia.png',
                ticker: 'hdd',
                precision: 12,
                network_fee: 0);
            break;

          case supported_forks.xcd:
            blockchain = Blockchain(
                name: 'DogeChia',
                unit: ' ',
                logo: '/icons/blockchains/chia.png',
                ticker: 'xcd',
                precision: 12,
                network_fee: 0);
            break;
          default:
            blockchain = Blockchain(
                name: 'Chia',
                unit: 'Mojo',
                logo: '/icons/blockchains/chia.png',
                ticker: 'xch',
                precision: 12,
                network_fee: 0);
        }

        Wallet wallet = Wallet(
          name: '',
          privateKey:
              const HexEncoder().convert(keyAddress.privateKey.toBytes()),
          publicKey: const HexEncoder().convert(keyAddress.publicKey.toBytes()),
          address: keyAddress.address,
          blockchain: blockchain,
          balance: balance.balance!,
        );
        print({
          'private key',
          const HexEncoder().convert(keyAddress.privateKey.toBytes())
        });
        print({
          'public key',
          const HexEncoder().convert(keyAddress.publicKey.toBytes())
        });
        print({'balance', balance.balance});
        return wallet;
      } else {
        throw Exception('${balanceResponse.body}');
      }
    } on Exception catch (e) {
      throw Exception('ERROR : ${e.toString()}');
    }
  }

  // @POST("/v1/balance")
  Future<int> fetchWalletBalance(Wallet activeWallet) async {
    print({"Checking balance for wallet:", activeWallet.address});
    String add =
        'xch1qpv3r5qt6e4q0vf7l2tkjqdh52txwrczmsn3rx4l7ytr6qz0lwcse4lcge';
    try {
      final responseData = await http.get(
        Uri.parse(
            'http://162.213.248.37:8081/v1/blockchain/${activeWallet.blockchain.ticker}/address/${activeWallet.address}/balance'),
      );

      if (responseData.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        BalanceResponse balanceResponse =
            BalanceResponse.fromJson(jsonDecode(responseData.body)['result']);
        print({"balance is:", balanceResponse.balance});

        return balanceResponse.balance!;
      } else {
        // If the server did not return a 200 OK response,
        baseResponse = BaseResponse.fromJson(jsonDecode(responseData.body));
        throw Exception('ERROR: ${baseResponse!.error}.');
      }
    } on Exception catch (e) {
      throw Exception('${e.toString()}.');
    }
  }

  // @GET("/v1/transactions")
  Future<TransactionsGroup> fetchWalletTransactions(Wallet activeWallet) async {
    try {
      final transactionsData = await http.post(
        Uri.parse(
            'http://162.213.248.37:8001/v1/blockchain/xch/address/${activeWallet.address}/transactions'),
      );

      if (transactionsData.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        TransactionListResponse transactionListResponse =
            TransactionListResponse.fromJson(
                jsonDecode(transactionsData.body)['result']);

        List<Transaction> transactionsList = [];
        for (TransactionGroupResponse transactions
            in transactionListResponse.transactions!) {
          for (TransactionsResponse t in transactions.transactions!) {
            Transaction transaction = Transaction(
                type: transactions.type!,
                timestamp: transactions.timestamp!,
                block: transactions.block!,
                address: ((t.sender != null) ? t.sender! : t.destination!),
                amount: t.amount,
                fee: transactions.fee!,
                baseAddress: activeWallet.address);
            transactionsList.add(transaction);
          }
        }
        return TransactionsGroup(
            address: activeWallet.address, transactionsList: transactionsList);
      } else {
        throw Exception('${transactionsData.body}');
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> sendXCH(
      {required String privateKey,
      required String address,
      required int amount,
      required int fee,
      required String ticker,
      required String blockChainExtraData}) async {
    SignedTransactionResponse? signedTransactionResponse;
    amount = 50000;
    blockChainExtraData =
        'ccd5bb71183532bff220ba46c268991a3ff07eb358e8255a65c30a2dce0e5fbb';
    var totalAmount = amount + fee;
    // await fetchBlockchainInfo();
    try {
      LocalSigner localSigner = LocalSigner();
      signedTransactionResponse = localSigner.usePrivateKeyToGenerateHash(
          '5fc21f77352cda508a3a3fd06f5676e8226a93fb1da99b7f0a35a29b7166c93b',
          ticker);
    } on Exception catch (e) {
      throw Exception('ERROR : ${e.toString()}');
    }
    String add =
        'xch1qpv3r5qt6e4q0vf7l2tkjqdh52txwrczmsn3rx4l7ytr6qz0lwcse4lcge';
    try {
      final responseData = await http.get(
        Uri.parse(
            'http://162.213.248.37:8001/v1/blockchain/$ticker/address/$add/utxos'),
      );

      print({'mine', jsonDecode(responseData.body)});

      if (responseData.statusCode == 200) {
        // print(jsonDecode(responseData.body));
        // }
        UtxosResponse recordsResponse =
            UtxosResponse.fromJson(jsonDecode(responseData.body));
        var records = recordsResponse.records;
        records.sort((a, b) => b.amount - a.amount);
        List<CoinResponse> spendRecords = [];
        var spendAmount = 0;
        calculator:
        while (records.isNotEmpty && spendAmount < totalAmount) {
          for (var i = 0; i < records.length; i++) {
            if (spendAmount + records[i].amount <= totalAmount) {
              var record = records.removeAt(i--);
              spendRecords.add(record);
              spendAmount += record.amount;
              continue calculator;
            }
          }
          var record = records.removeAt(0);
          spendRecords.add(record);
          spendAmount += record.amount;
        }

        if (spendAmount < totalAmount) {
          return 'Insufficient funds.';
        }
        var change = spendAmount - amount - fee;
        List<JacobianPoint> signatures = [];
        List<Map<String, dynamic>> spends = [];
        var target = true;
        var receiverAddress = address.isEmpty
            ? 'xch1a5vu46axpyzl554y3ku8sredpv74r0smjk6nlmqjmmud8jjq9zzqrr7agt'
            : address;
        var destinationHash = segwit.decode(receiverAddress).program;

        for (var record in spendRecords) {
          var conditions = Program.list(target
              ? [
                    Program.list([
                      Program.int(51),
                      Program.atom(Uint8List.fromList(destinationHash)),
                      Program.int(amount)
                    ])
                  ] +
                  (change > 0
                      ? [
                          Program.list([
                            Program.int(51),
                            Program.atom(signedTransactionResponse.puzzleHash),
                            Program.int(change)
                          ])
                        ]
                      : [])
              : []);
          var solution = Program.list([conditions]);
          target = false;
          var coinId = Program.list([
            Program.int(11),
            Program.cons(Program.int(1),
                Program.hex(record.parentCoinInfo.substring(2))),
            Program.cons(
                Program.int(1), Program.hex(record.puzzleHash.substring(2))),
            Program.cons(Program.int(1), Program.int(record.amount))
          ]).run(Program.nil()).program.atom;
          signatures.add(AugSchemeMPL.sign(
              signedTransactionResponse.privateKeyObject,
              Uint8List.fromList(conditions.hash() +
                  coinId +
                  const HexDecoder().convert(blockChainExtraData))));
          spends.add({
            'coin': record.toJson(),
            'puzzle_reveal': const HexEncoder()
                .convert(signedTransactionResponse.wallet.serialize()),
            'solution': const HexEncoder().convert(solution.serialize())
          });
        }
        var aggregate = AugSchemeMPL.aggregate(signatures);
        var aggSig = const HexEncoder().convert(aggregate.toBytes());
        var body = {
          'tx': {'aggregated_signature': aggSig, 'coin_spends': spends}
        };
        print(jsonEncode(body));
        try {
          final responseData = await http.post(
              Uri.parse('http://162.213.248.37:8001/v1/blockchain/xch/send'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(body));
          print(responseData.statusCode);
          print(responseData.reasonPhrase);
          print(jsonDecode(responseData.body));

          // if (responseData.statusCode == 200) {
          //   return 'success';
          // } else {
          //   return responseData.body;
          // }
          return 'SUCCESS';
        } on Exception catch (e) {
          return e.toString();
        }
      } else {
        return responseData.body;
      }
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<Blockchain> fetchBlockchainInfo() async {
    try {
      final blockchainResponse = await http.post(
        Uri.parse('https://arborwallet.com/api/v2/blockchain'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'blockchain': 'xch',
        }),
      );

      print(jsonDecode(blockchainResponse.body));

      if (blockchainResponse.statusCode == 200) {
        BlockchainResponse blockchainResponseModel =
            BlockchainResponse.fromJson(jsonDecode(blockchainResponse.body));

        Blockchain blockchain = Blockchain(
          name: blockchainResponseModel.blockchainData!.name,
          ticker: blockchainResponseModel.blockchainData!.ticker,
          unit: blockchainResponseModel.blockchainData!.unit,
          precision: blockchainResponseModel.blockchainData!.precision,
          logo: blockchainResponseModel.blockchainData!.logo,
          network_fee: blockchainResponseModel.blockchainData!.blockchainFee,
        );

        return blockchain;
      } else {
        throw Exception(blockchainResponse.body);
      }
    } on Exception catch (e) {
      throw Exception('ERROR : ${e.toString()}');
    }
  }

  Future<double> getChiaUSDPRice() async {
    final xchange =
        await http.get(Uri.parse('https://xchscan.com/api/chia-price'));
    if (xchange.statusCode == 200) {
      var usd_chia = USDChia.fromJson(xchange.body);
      print('successful, the usd to chia price is: $usd_chia');
      print('chia is usd is: ${usd_chia.usd}');
      return usd_chia.usd;
    }
    print('failed to convert successfully');
    print(xchange.body);

    return 0.0;
  }
}
