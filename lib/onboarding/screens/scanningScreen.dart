import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:jumper/bluetooth/bluetooth.dart';

class ScanningScreen extends StatefulWidget{
  const ScanningScreen({super.key});

  @override
  State<StatefulWidget> createState() => ScanningScreenState();
}

class ScanningScreenState extends State{

  //TODO: Bluetooth should be handled in a onboarding coordinator, and have this use that instead
  final Bluetooth bluetooth = Bluetooth();

  List<BluetoothDevice> _vectors = [];
  StreamSubscription<BluetoothDevice>? _scanSubscription;

  void _startScan() {
    setState(() {
      _vectors.clear();
    });
    _scanSubscription = bluetooth.scanForVectors().listen((device) {
      setState(() {
        _vectors.add(device);
      });
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child:  ListView.builder(
                        shrinkWrap: true,
                        itemCount: _vectors.length,

                        itemBuilder: (context, index) {
                          final vector = _vectors[index];

                          return ListTile(
                          title: Text(vector.advName),
                          trailing: ElevatedButton(onPressed: () => bluetooth.connectToVector(vector), child: const Text("Connect!")),
                        );
                        },
                      ),
            ),
            ElevatedButton(onPressed: _startScan, child: Text("start scan!"))
          ],
        ),
      ),
    );
  }

}