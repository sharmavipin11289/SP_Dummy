import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';

class OrderConfirmScreen extends StatelessWidget {
  const OrderConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
      },
      child: Scaffold(
        /*appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              NavigationService.goBack();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(back),
            ),
          ),
          title: Text(""),
          centerTitle: true,
          elevation: 0,
        ),*/
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              orderSuccess,
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: 67,
            ),
            Text(
              AppLocalizations.of(context)?.orderConfirmed ?? "Order Confirmed!",
              style: FontStyles.getStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                AppLocalizations.of(context)?.yourOrderConfirmed ?? "Your order has been confirmed, we will send you confirmation email shortly.",
                textAlign: TextAlign.center,
                style: FontStyles.getStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            InkWell(
              onTap: () async {
                NavigationService.navigateTo('/orderList', arguments: true);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 26),
                height: 50,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white, border: Border.all(width: 1)),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)?.goToOrders ?? 'Go To Orders',
                    style: FontStyles.getStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () async {
                NavigationService.navigateAndClearStack('/mainPage');
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 26),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)?.continueShopping ?? 'Continue Shopping',
                    style: FontStyles.getStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
