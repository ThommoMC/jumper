import 'package:flutter_blue_plus/flutter_blue_plus.dart';


void init() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose);
}


Future<void> scanForDevices() async {
  var subscription = FlutterBluePlus.onScanResults.listen((results) {
        if (results.isNotEmpty) {
            ScanResult r = results.last; // the most recently found device
            print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
        }
    },
    onError: (e) => print(e),
);

// cleanup: cancel subscription when scanning stops
FlutterBluePlus.cancelWhenScanComplete(subscription);

// Wait for Bluetooth enabled & permission granted
// In your real app you should use `FlutterBluePlus.adapterState.listen` to handle all states
await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;

// Start scanning w/ timeout
// Optional: use `stopScan()` as an alternative to timeout
await FlutterBluePlus.startScan(
  withServices: [Guid("FEE3")],
  timeout: Duration(seconds:15));

// wait for scanning to stop
await FlutterBluePlus.isScanning.where((val) => val == false).first;
}