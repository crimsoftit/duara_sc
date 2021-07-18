import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ViewAssetsModel extends ChangeNotifier {
  ViewAssetsModel() {
    initiateSetup();
  }

  int assetCount = 0;
  List<Asset> assets = [];
  bool isLoading = true;

  List rows = [
    {"ags": "01224", "name": "Test-1"},
    {"ags": "01224", "name": "Test-1"},
    {"ags": "22222", "name": "Test-2"},
  ];

  // ignore: avoid_init_to_null
  // ignore: unused_field
  late String _abiCode;
  late String msg;

  late ContractFunction _assetCount;
  late ContractFunction _assets;
  late ContractFunction _createAsset;
  late ContractFunction _getNameFromCode;
  late ContractEvent _assetCreatedEvent;

  late Web3Client _client;

  late DeployedContract _contract;
  late EthereumAddress _contractAddress;
  late EthereumAddress _ownAddress;
  late Credentials _credentials;

  final String _privateKey =
      "f6fb55a254616225d233e3ed3baf345b8437f08294cce5967e32d10081b15f5a";

  //final String _rpcUrl = "http://192.168.43.227:7545";
  //final String _wsUrl = "ws://192.168.43.227:7545/";
  final String _rpcUrl = "http://192.168.43.226:7545";
  final String _wsUrl = "ws://192.168.43.226:7545/";
  // final String _rpcUrl = "http://192.168.42.231:7545";
  // final String _wsUrl = "ws://192.168.42.231:7545/";

  late var data;

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbis();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbis() async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/AssetManager.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
    print(_abiCode);
    print(_contractAddress);
  }

  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "AssetManager"), _contractAddress);
    _getNameFromCode = _contract.function("getNameFromCode");
    _assetCount = _contract.function("assetCount");
    _assets = _contract.function("assets");
    _createAsset = _contract.function("createAsset");
    print("done with getDeployedContract() function");
    getAssets();
    //isDataExist();
  }

  Future<void> getAssets() async {
    List totalAssetsList = await _client
        .call(contract: _contract, function: _assetCount, params: []);
    BigInt totalAssets = totalAssetsList[0];
    assetCount = totalAssets.toInt();
    //print(totalAssets);
    assets.clear();
    for (var i = 0; i < totalAssets.toInt(); i++) {
      var temp = await _client.call(
          contract: _contract, function: _assets, params: [BigInt.from(i)]);
      assets.add(Asset(assetCode: temp[0], assetName: temp[1]));
    }
    //print(assets[0].assetCode + " " + assets[0].assetName);
    //print(assets);
    isLoading = false;
    notifyListeners();
    getAssetByCode("man_code");
  }

  getAssetByCode(String value) {
    data = assets.where((row) => (row.assetCode.contains(value)));
    print(data.length);
    if (data.length >= 1) {
      print("true");
    } else {
      print("false");
    }
  }

  Future<void> addAsset(String assetCodeData, String assetNameData) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _createAsset,
            parameters: [assetCodeData, assetNameData]));
    getAssets();
  }
}

class Asset {
  Asset({required this.assetCode, required this.assetName});

  String assetCode;
  String assetName;
}
