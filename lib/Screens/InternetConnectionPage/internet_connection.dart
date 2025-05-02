import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  //final VoidCallback onRetry;

  const NoInternetPage({/*required this.onRetry,*/ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 100,
              color: Colors.grey,
            ),
             SizedBox(height: 20),
             Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 10),
             Text(
              'Please check your network settings.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
             SizedBox(height: 30),
            /*ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),*/
          ],
        ),
      ),
    );
  }
}
