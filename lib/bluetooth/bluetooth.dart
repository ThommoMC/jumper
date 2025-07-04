import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:jumper/bluetooth/fragmentation.dart';

enum PairingStage {
  NotConnected,
  Handshake,
  Encryption,
  Nonce,
  Challenge,
  Connected
}


class Bluetooth {
  BluetoothDevice? _vector;
  BluetoothCharacteristic? _vectorReading;
  BluetoothCharacteristic? _vectorWriting;

  PairingStage connectionStage = PairingStage.NotConnected;
  int cladVersion = 0;

  ReassmembledMessage? _reassmembledMessage;

  Stream<BluetoothDevice> scanForVectors() {
    FlutterBluePlus.startScan(
    withServices: [Guid("FEE3")],
    timeout: const Duration(seconds: 10)
    );

    return FlutterBluePlus.scanResults
      .expand((List<ScanResult> results) => results)
      .map((ScanResult result) => result.device)
      .distinct();
  }

  Future<void> connectToVector(BluetoothDevice vector) async {
    _vector = vector;
    print("connecting");
    await vector.connect();
    print("connected! subbing to service");
    List<BluetoothService> services = await vector.discoverServices();
  
    _vectorReading = services[2].characteristics[0];
    _vectorWriting = services[2].characteristics[1];
    final readSubscription = _vectorReading?.onValueReceived.listen(handleIncomingMessage);
    vector.cancelWhenDisconnected(readSubscription as StreamSubscription);
    await _vectorReading?.setNotifyValue(true);
    connectionStage = PairingStage.Handshake;
  }

  sendMessage(List<int> message) async {
    print('sending message');
    await _vectorWriting?.write(message);
  }

  bool handleIncomingMessage(List<int> message) {
    print(message);
    switch (connectionStage) {
      case PairingStage.NotConnected : throw("Recivied message while not connected!");
      case PairingStage.Handshake: {
        print('at handshake stage');
        // We can safely ignore fragmentation here
        // Clad version is also always going to be in that slot of the array too
        cladVersion = message[2];
        print('set clad version to $cladVersion');
        sendMessage(message);
        connectionStage = PairingStage.Encryption;
      }
      case PairingStage.Encryption: {
        print('at encryption stage');
        if(_reassmembledMessage == null) {
          _reassmembledMessage = ReassmembledMessage.fromMessages(message);
        } else {
          if (_reassmembledMessage?.finished != true) {
            _reassmembledMessage?.addMessage(message);
            print('printing message...');
            print(_reassmembledMessage?.message);
          }
        }
      }
      default: throw('not implemented!');
    }
    return true;
  }

}