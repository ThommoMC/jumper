import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:jumper/bluetooth/bluetooth.dart';

class OnboardingCoordinator extends ChangeNotifier {

  final Bluetooth _bluetooth = Bluetooth();

  PairingStage pairingStage = PairingStage.NotConnected;

  List<BluetoothDevice> foundVectors = [];

  StreamSubscription? _scanSub;

  void scanForVectors() async {
    _scanSub?.cancel();
    foundVectors.clear();
    notifyListeners();

    _scanSub = _bluetooth.scanForVectors().listen((vector) {
      if (!foundVectors.contains(vector)) {
        foundVectors.add(vector);
        notifyListeners();
      }
    });
  }

  void connectToVector(BluetoothDevice vector) {
    _bluetooth.connectToVector(vector);
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    super.dispose();
  }

}