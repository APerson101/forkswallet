import 'dart:io';
import 'dart:typed_data';
import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/views/widgets/arbor_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arbor/models/models.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
//import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:ui' as ui;

class WalletReceiveScreen extends StatefulWidget {
  const WalletReceiveScreen({
    required this.index,
    required this.wallet,
  });

  final int index;
  final Wallet wallet;

  @override
  _WalletReceiveScreenState createState() => _WalletReceiveScreenState();
}

class _WalletReceiveScreenState extends State<WalletReceiveScreen> {
  static GlobalKey globalKey =
      new GlobalKey(debugLabel: 'wallet_receive_screen');
  static const double PASSWORD_PADDING = 40;

  void shareQrCode(String address) async {
    try {
      final qrValidationResult = QrValidator.validate(
          data: address,
          version: QrVersions.auto,
          errorCorrectionLevel: QrErrorCorrectLevel.L);
      if (qrValidationResult.isValid) {
        RenderRepaintBoundary boundary = globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;

        ui.Image image = await boundary.toImage();
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          Uint8List pngBytes = byteData.buffer.asUint8List();

          final tempDir = (await getTemporaryDirectory()).path;
          var file =
              await new File('${tempDir}/wallet-receive-address.png').create();
          await file.writeAsBytes(pngBytes);

          await Share.shareFiles(
            [file.path],
            mimeTypes: ['images/png'],
            subject: '${widget.wallet.blockchain.name} Wallet Address',
            text:
                '${widget.wallet.blockchain.name} (${widget.wallet.blockchain.ticker.toUpperCase()}) Address:\n${widget.wallet.address}',
          );
        }
      } else {
        String _errorMessage = qrValidationResult.error.toString();
        showSnackBar(context, '$_errorMessage', ArborColors.errorRed);
      }
    } on Exception catch (e) {
      showSnackBar(context, '${e.toString()}', ArborColors.errorRed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Get.theme.backgroundColor,
            leading: IconButton(
              icon: const Icon(
                Icons.close,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // title: Text('Receive ${widget.wallet.fork.name} (${widget.wallet.name})'),
            title: Text(
              'Receive ${widget.wallet.blockchain.name}',
            ),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(
                PASSWORD_PADDING, PASSWORD_PADDING, PASSWORD_PADDING, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RepaintBoundary(
                  key: globalKey,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: QrImage(
                            data: widget.wallet.address,
                            size: 250,
                            version: QrVersions.auto,
                            embeddedImage: AssetImage('assets/images/logo.png'),
                            backgroundColor:
                                Get.isDarkMode ? Colors.white : Colors.black,
                            foregroundColor:
                                !Get.isDarkMode ? Colors.white : Colors.black,
                            gapless: false,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Tap to copy your ${widget.wallet.blockchain.name} light wallet address:',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          child: ListTile(
                            title: Text(
                              widget.wallet.address,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            trailing: Icon(Icons.copy),
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: widget.wallet.address));
                              showSnackBar(context, 'Wallet address copied',
                                  ArborColors.deepGreen);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                ArborButton(
                  onPressed: () {
                    shareQrCode(widget.wallet.address);
                  },
                  title: 'Share',
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$message"),
        duration: Duration(milliseconds: 1000),
        backgroundColor: Get.theme.backgroundColor,
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
