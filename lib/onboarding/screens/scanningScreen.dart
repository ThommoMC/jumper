import 'package:flutter/material.dart';
import 'package:jumper/onboarding/onboarding_coordinator.dart';
import 'package:provider/provider.dart';

class ScanningScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Scanning for Vectors..."),
            Icon(Icons.search),
            SizedBox(
              height: 300,
              width: 300,
              child: Consumer<OnboardingCoordinator>(
              builder: (context, coordinator, child) => ListView.builder(
                itemCount: coordinator.foundVectors.length,
                itemBuilder: (context, index) {
                  final vector = coordinator.foundVectors[index];
                  return ListTile(
                    leading: Text(vector.advName),
                    trailing: ElevatedButton(onPressed: () {coordinator.connectToVector(vector);}, child: Text("Connect")),
                  );
              }, ),
            ),
            ),
            ElevatedButton(onPressed: () {context.read<OnboardingCoordinator>().scanForVectors();}, child: const Text("Scan"))
          ],
        ),
      ),
    );
  }
  
}