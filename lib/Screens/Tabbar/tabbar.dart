import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:sanaa/Screens/Account/account_page.dart';
import 'package:sanaa/Screens/HomePage/home_page.dart';
import 'package:sanaa/Screens/MyCartPage/mycart_page.dart';
import 'package:sanaa/Screens/Tabbar/tabbar_notifier.dart';
import 'package:sanaa/Screens/WishlistPage/wishlist_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';

class Mainpage extends StatefulWidget {
  Mainpage({Key? key}) : super(key: key);

  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final List<Widget> _pages = [
    const HomePage(),
    WishListPage(),
    MyCartPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Access TabControllerProvider
    final tabController = Provider.of<TabControllerProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          _pages[tabController.currentIndex], // Use currentIndex from provider
          if (!networkStatus.isOnline)
            Center(
              child: Text(
                AppLocalizations.of(context)?.noInternetConnection ??
                    "No internet connection...",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: tabController.currentIndex, // Use currentIndex from provider
        onTap: (index) {
          if (index > 0 && !isUserLoggedIn()) {
            showLoginAlert(context);
          } else {
            tabController.changeTabIndex(index); // Update index via provider
          }
        },
        selectedItemColor: Color(0xFF318531),
        unselectedItemColor: Colors.black,
        selectedIconTheme: IconThemeData(color: Color(0xFF318531)),
        unselectedIconTheme: IconThemeData(color: Colors.black),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              home,
              width: 20,
              height: 20,
              colorBlendMode: BlendMode.srcIn,
              color: (tabController.currentIndex == 0)
                  ? Color(0xFF318531)
                  : Colors.black,
            ),
            label: AppLocalizations.of(context)?.home ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              heartBlack,
              width: 20,
              height: 20,
              colorBlendMode: BlendMode.srcIn,
              color: (tabController.currentIndex == 1)
                  ? Color(0xFF318531)
                  : Colors.black,
            ),
            label: AppLocalizations.of(context)?.wishlist ?? 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              cartBlack,
              width: 20,
              height: 20,
              colorBlendMode: BlendMode.srcIn,
              color: (tabController.currentIndex == 2)
                  ? Color(0xFF318531)
                  : Colors.black,
            ),
            label: AppLocalizations.of(context)?.cart ?? 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              personBlack,
              width: 20,
              height: 20,
              colorBlendMode: BlendMode.srcIn,
              color: (tabController.currentIndex == 3)
                  ? Color(0xFF318531)
                  : Colors.black,
            ),
            label: AppLocalizations.of(context)?.profile ?? 'Profile',
          ),
        ],
      ),
    );
  }
}