import 'package:flutter/material.dart';

class AddressDetails extends StatelessWidget {
  AddressDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back_ios_new)),
            title: Text("Address details",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold)),
          ),
        ),
        Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Column(children: [
              RichText(
                  text: TextSpan(text: "Private key", children: [
                TextSpan(text: "sf834oiutlkhrt8o34i7uyklthjew84tew5vyhfg")
              ])),
              RichText(
                  text: TextSpan(text: "Public key", children: [
                TextSpan(
                    text: "sf834oiutlkhrt8o34i7uykltdfsgdugjeohjew84tew5vyhfg")
              ])),
              RichText(
                  text: TextSpan(text: "Address", children: [
                TextSpan(text: "s4985itykhjdgo3 i4ukhrjilrukyt349tie")
              ])),
            ]))
      ],
    ));
  }
}
