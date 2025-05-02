import 'package:flutter/material.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:sanaa/main.dart';

import 'CommonFiles/image_file.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome(){
      Future.delayed(Duration(seconds: 2), () {
        NavigationService.navigateAndClearStack('/onBoard');
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.sizeOf(context).height,
        child: Image.asset(splash,fit: BoxFit.fill,),
      ),
    );
  }
}
