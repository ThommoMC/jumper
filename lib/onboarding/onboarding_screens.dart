import 'package:flutter/widgets.dart';
import 'package:jumper/onboarding/onboarding_coordinator.dart';
import 'package:jumper/onboarding/screens/scanningScreen.dart';
import 'package:provider/provider.dart';

class OnboardingScreens extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _OnboardingScreensState();
}
class _OnboardingScreensState extends State<OnboardingScreens> {

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingCoordinator(),
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ScanningScreen()
        ],
      )
    );
    
  }

}