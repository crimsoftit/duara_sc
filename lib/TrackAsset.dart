import 'package:duara_sc/ViewAssetsModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrackAsset extends StatelessWidget {
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
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 5.0, top: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          //Navigator.push(
                          //context,
                          //MaterialPageRoute(
                          //builder: (context) => HomePage()));
                          //listModel.addAsset(name.text, bCodeValue.text);
                        },
                        child: new Container(
                            alignment: Alignment.center,
                            height: 60.0,
                            decoration: new BoxDecoration(
                                color: Color(0xFF18D191),
                                borderRadius: new BorderRadius.circular(9.0)),
                            child: new Text("Save",
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white))),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                        title: Row(children: <Widget>[
                          new Expanded(child: new Text("asset name")),
                          new Expanded(child: new Text("Bar Code")),
                        ]),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                        title: Row(children: <Widget>[
                          new Expanded(
                              child: new Text(
                                  "listModel.assets[index].assetName")),
                          new Expanded(
                              child: new Text(
                                  "listModel.assets[index].qrCodeString")),
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
