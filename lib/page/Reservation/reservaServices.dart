import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testprojectbc/Service/provider/reservationBlockchian.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:convert/convert.dart';

class NotesServices extends ChangeNotifier {
  List<Note> notes = [];
  final String _rpcUrl =
      Platform.isAndroid ? 'http://10.0.2.2:7545' : 'HTTP://127.0.0.1:7545';
  final String _wsUrl =
      Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';
  bool isLoading = true;

  final String _privatekey =
      '0xd60ed024407d209e8c5a1fe2d4bc9caa32c7af6ff821a332df3ee28b4dc472ee';
  late Web3Client _web3cient;

  NotesServices() {
    init();
  }

  Future<void> init() async {
    _web3cient = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('build/contracts/NotesContract.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode =
        ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'NotesContract');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
    print('Decode ABI: $_contractAddress');
  }

  late EthPrivateKey _creds;
  late EthereumAddress _ownAddress;
  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
    _ownAddress = await _creds.address;
    print('key: $_privatekey');
    print('_creds: $_creds');
    print('_ownAddress: $_ownAddress');
  }

  late DeployedContract _deployedContract;
  late ContractFunction _createNote;
  late ContractFunction _deleteNote;
  late ContractFunction _notes;
  late ContractFunction _noteCount;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createNote = _deployedContract.function('createNote');
    _deleteNote = _deployedContract.function('deleteNote');
    _notes = _deployedContract.function('notes');
    _noteCount = _deployedContract.function('noteCount');
    await fetchNotes();
  }

  // Future<void> fetchNotes() async {
  //   List totalTaskList = await _web3cient.call(
  //     contract: _deployedContract,
  //     function: _noteCount,
  //     params: [],
  //   );

  //   int totalTaskLen = totalTaskList[0].toInt();
  //   notes.clear();
  //   for (var i = 0; i < totalTaskLen; i++) {
  //     var temp = await _web3cient.call(
  //         contract: _deployedContract,
  //         function: _notes,
  //         params: [BigInt.from(i)]);
  //     if (temp[1] != "") {
  //       notes.add(
  //         Note(
  //             id: (temp[0] as BigInt).toInt(),
  //             title: temp[1],
  //             description: temp[2],
  //             currencyBC: temp[3],
  //             rateBC: temp[4],
  //             amountBC: temp[5],
  //             dateBC: temp[6]),
  //       );
  //     }
  //   }
  //   isLoading = false;

  //   notifyListeners();
  // }

  Future<void> fetchNotes() async {
    List totalTaskList = await _web3cient.call(
      contract: _deployedContract,
      function: _noteCount,
      params: [],
    );

    int totalTaskLen = totalTaskList[0].toInt();
    notes.clear();
    if (totalTaskLen > 0) {
      for (var i = 0; i < totalTaskLen; i++) {
        var temp = await _web3cient.call(
            contract: _deployedContract,
            function: _notes,
            params: [BigInt.from(i)]);
        if (temp.isNotEmpty && temp[1] != "") {
          notes.add(
            Note(
                id: (temp[0] as BigInt).toInt(),
                agencyBC: temp[1],
                currencyBC: temp[2],
                rateBC: temp[3],
                amountBC: temp[4],
                totalBC: temp[5],
                dateBC: temp[6]),
          );
        }
        print("temp: $temp");
      }
    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> addNote(String agencyBC, String currencyBC, String rateBC,
      String amountBC, String totalBC, String dateBC) async {
    BigInt cId = await _web3cient.getChainId();
    await _web3cient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _createNote,
        parameters: [agencyBC, currencyBC, rateBC, amountBC, totalBC, dateBC],
      ),
      chainId: cId.toInt(),
    );
    isLoading = true;
    fetchNotes();
  }

  // Future<void> addNote(String title, String description, String currencyBC,
  //     String rateBC, String amountBC, String dateBC) async {
  //   final jsonMap = {
  //     'title': title,
  //     'description': description,
  //     'currency': currencyBC,
  //     'rate': rateBC,
  //     'amount': amountBC,
  //     'date': dateBC,
  //   };
  //   final json = jsonEncode(jsonMap);

  //   final jsonBytes = utf8.encode(json);
  //   final hexData = hex.encode(jsonBytes);

  //   BigInt cId = await _web3cient.getChainId();
  //   await _web3cient.sendTransaction(
  //     _creds,
  //     Transaction.callContract(
  //       contract: _deployedContract,
  //       function: _createNote,
  //       parameters: [hexData],
  //     ),
  //     chainId: cId.toInt(),
  //   );

  //   isLoading = true;
  //   fetchNotes();
  // }

  Future<void> deleteNote(int id) async {
    BigInt cId = await _web3cient.getChainId();
    await _web3cient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _deleteNote,
        parameters: [BigInt.from(id)],
      ),
      chainId: cId.toInt(),
    );
    isLoading = true;
    notifyListeners();
    fetchNotes();
  }

  // Future<void> addToBlockchain(String json) async {
  //   final jsonBytes = utf8.encode(json);
  //   final hexData = hex.encode(jsonBytes);

  //   BigInt cId = await _web3cient.getChainId();
  //   await _web3cient.sendTransaction(
  //     _creds,
  //     Transaction.callContract(
  //       contract: _deployedContract,
  //       function: _createNote,
  //       parameters: [hexData],
  //     ),
  //     chainId: cId.toInt(),
  //   );

  //   isLoading = true;
  //   fetchNotes();
  // }
}
