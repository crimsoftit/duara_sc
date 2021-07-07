import 'package:duara_sc/ViewAssetsModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAssets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<ViewAssetsModel>(context);

    final title = 'Registered Assets';
    //final items = List<String>.generate(100, (i) => "Item $i");

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: listModel.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                        title: Row(children: <Widget>[
                          new Expanded(child: new Text("Asset code")),
                          new Expanded(child: new Text("Asset name")),
                        ]),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: listModel.assetCount,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                        title: Row(children: <Widget>[
                          new Expanded(
                              child:
                                  new Text(listModel.assets[index].assetCode)),
                          new Expanded(
                              child:
                                  new Text(listModel.assets[index].assetName)),
                        ]),
                        //Text(listModel.assets[index].assetName +
                        //listModel.assets[index].qrCodeString),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
