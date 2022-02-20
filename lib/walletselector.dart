import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletSelector extends StatelessWidget {
  WalletSelector({Key? key}) : super(key: key);
  RxList<bool> panelsOpen = List<bool>.filled(3, false).obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.keyboard_backspace_rounded)),
          title: Text("Select Account",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Obx(() => ExpansionPanelList(
                expansionCallback: (panel, status) {
                  panelsOpen[panel] = !panelsOpen[panel];
                },
                children: [
                  ExpansionPanel(
                      backgroundColor: Color(0xFF393939),
                      canTapOnHeader: true,
                      isExpanded: panelsOpen[0],
                      headerBuilder: (context, isOpen) {
                        return ListTile(
                          leading: FlutterLogo(
                            size: 24,
                          ),
                          title: Text("Chia"),
                          subtitle: Text("45 XCH",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.grey)),
                          trailing: Text("\$400",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                        );
                      },
                      body: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: ListTile(
                                onTap: () {},
                                leading: Icon(Icons.drag_indicator),
                                title: Text("xchh845....j984"),
                                subtitle: Text("4 XCH",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: Colors.grey)),
                                trailing: Text("\$400",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: ListTile(
                                onTap: () {},
                                leading: Icon(Icons.drag_indicator),
                                title: Text("xchh845....j984"),
                                subtitle: Text("4 XCH",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: Colors.grey)),
                                trailing: Text("\$400",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: ListTile(
                                onTap: () {},
                                leading: Icon(Icons.drag_indicator),
                                title: Text("xchh845....j984"),
                                subtitle: Text("4 XCH",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: Colors.grey)),
                                trailing: Text("\$400",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: ListTile(
                                onTap: () async {
                                  await Get.defaultDialog(
                                      title: "Confirmation",
                                      content: Text("Switch to this wallet?"),
                                      onCancel: () {},
                                      onConfirm: () {
                                        Get.back();
                                        Get.back();
                                      });
                                },
                                leading: Icon(Icons.drag_indicator),
                                title: Text("xch845....j9q4"),
                                subtitle: Text("4 XCH",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: Colors.grey)),
                                trailing: Text("\$400",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: ListTile(
                                onTap: () {},
                                leading: Icon(Icons.drag_indicator),
                                title: Text("xchh845....j984"),
                                subtitle: Text("4 XCH",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: Colors.grey)),
                                trailing: Text("\$400",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      )),
                  ExpansionPanel(
                      canTapOnHeader: true,
                      isExpanded: panelsOpen[1],
                      headerBuilder: (context, isOpen) {
                        return ListTile(
                          leading: FlutterLogo(
                            size: 24,
                          ),
                          title: Text("DogeChia"),
                          subtitle: Text("45 XCD",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.grey)),
                          trailing: Text("\$400",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                        );
                      },
                      body: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.drag_indicator),
                            title: Text("xcd845....j984"),
                            subtitle: Text("4 XCD",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            trailing: Text("\$400",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                          ListTile(
                            leading: Icon(Icons.drag_indicator),
                            title: Text("xch845....j984"),
                            subtitle: Text("4 XCH",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            trailing: Text("\$400",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                          ListTile(
                            leading: Icon(Icons.drag_indicator),
                            title: Text("xchh845....j984"),
                            subtitle: Text("4 XCH",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            trailing: Text("\$400",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                          ListTile(
                            leading: Icon(Icons.drag_indicator),
                            title: Text("xchh845....j984"),
                            subtitle: Text("4 XCH",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            trailing: Text("\$400",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                          ListTile(
                            leading: Icon(Icons.drag_indicator),
                            title: Text("xchh845....j984"),
                            subtitle: Text("4 XCH",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            trailing: Text("\$400",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                          ListTile(
                            leading: Icon(Icons.drag_indicator),
                            title: Text("xchh845....j984"),
                            subtitle: Text("4 XCH",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            trailing: Text("\$400",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )),
                  ExpansionPanel(
                      canTapOnHeader: true,
                      isExpanded: panelsOpen[2],
                      headerBuilder: (context, isOpen) {
                        return ListTile(
                          leading: FlutterLogo(
                            size: 24,
                          ),
                          title: Text("Flora"),
                          subtitle: Text("45 XCH",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.grey)),
                          trailing: Text("\$400",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                        );
                      },
                      body: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.drag_indicator),
                            title: Text("xchh845....j984"),
                            subtitle: Text("4 XCH",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            trailing: Text("\$400",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                          ListTile(
                            leading: Icon(Icons.drag_indicator),
                            title: Text("xchh845....j984"),
                            subtitle: Text("4 XCH",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            trailing: Text("\$400",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                          ListTile(
                            leading: Icon(Icons.drag_indicator),
                            title: Text("xchh845....j984"),
                            subtitle: Text("4 XCH",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            trailing: Text("\$400",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                          ListTile(
                            leading: Icon(Icons.drag_indicator),
                            title: Text("xchh845....j984"),
                            subtitle: Text("4 XCH",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            trailing: Text("\$400",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                          ListTile(
                            leading: Icon(Icons.drag_indicator),
                            title: Text("xchh845....j984"),
                            subtitle: Text("4 XCH",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            trailing: Text("\$400",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                          ListTile(
                            leading: Icon(Icons.drag_indicator),
                            title: Text("xchh845....j984"),
                            subtitle: Text("4 XCH",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey)),
                            trailing: Text("\$400",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )),
                ],
              )),
        ));
  }
}
