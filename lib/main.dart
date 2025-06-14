import 'package:flutter/material.dart';
import 'ble.dart';

void main() {
  runApp(const Jumper());
}

class Jumper extends StatelessWidget {
  const Jumper({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jumper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BluetoothOffPage(),
    );
  }
}

class DevScreenPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("The Dev Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: scanForDevices, child: const Text("Scan!"))
          ],
        ),
      ),
    );
  }
}

class BluetoothOffPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("No Bluetooth!")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bluetooth_disabled),
            Text("Please re-enable bluetooth")
          ],
        ),
      ),
    );
  }
  
}