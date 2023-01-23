import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:hex/hex.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter web3 1559 test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Web3Screen(),
    );
  }
}

class Web3Screen extends StatefulWidget {
  const Web3Screen({super.key});

  @override
  State<Web3Screen> createState() => _Web3ScreenState();
}

class _Web3ScreenState extends State<Web3Screen> {
  String privateKey =
      'privatekey';
  String rpcUrl = 'rpc url';


  ///EIP 1559 support
  Future<void> sendTransaction() async {
    // start a client we can use to send transactions
    final client = Web3Client(rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address;

    print(address.hexEip55);
    print(await client.getBalance(address));

    ///EIP1559 plugin used
    final feeList = await client.getGasInEIP1559();
    print(feeList);

    final maxPriorityFeePerGas = EtherAmount.fromInt(EtherUnit.gwei, 1);
    final maxFeePerGas = EtherAmount.fromInt(EtherUnit.gwei, 25);
    final tx = Transaction(
      from:
          EthereumAddress.fromHex('from_address'),
      to: EthereumAddress.fromHex('to_address'),
      ///1559 support not use gasprice
      //gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 25),
      maxGas: 21000,
      nonce: 4,
      value: EtherAmount.fromInt(EtherUnit.wei, 1),
      maxFeePerGas: maxFeePerGas,
      maxPriorityFeePerGas: maxPriorityFeePerGas,
    );


    final signTransaction =
        await client.signTransaction(credentials, tx, chainId: 43113);
    ///sign transaction and send (EIP 1559) require prependTransactionType
    final signed = prependTransactionType(0x02, signTransaction);
        
    log(HEX.encode(signed));
  }

  @override
  void initState() {
    sendTransaction();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
