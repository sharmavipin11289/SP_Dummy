import 'package:flutter/material.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:sanaa/Screens/Account/account_page.dart';
import 'package:sanaa/Screens/HomePage/home_page.dart';
import 'package:sanaa/Screens/MyCartPage/mycart_page.dart';
import 'package:sanaa/Screens/WishlistPage/wishlist_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [const HomePage(), WishListPage(), MyCartPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          if (!networkStatus.isOnline)
            Center(
              child: Text(
                AppLocalizations.of(context)?.noInternetConnection ?? "No internet connection...",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
        ],
      ), // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index > 0 && !isUserLoggedIn()){
              showLoginAlert(context);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        selectedItemColor: Color(0XFF318531),
        // Color when selected
        unselectedItemColor: Colors.black,
        selectedIconTheme: IconThemeData(
          color: Color(0XFF318531),
        ),
        // Color when not selected
        unselectedIconTheme: IconThemeData(
          color: Colors.black,
        ),
        // Color when not selected,

        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              home,
              width: 20,
              height: 20,
              colorBlendMode: BlendMode.srcIn,
              color: (_currentIndex == 0) ? Color(0XFF318531) : Colors.black,
            ),
            label: AppLocalizations.of(context)?.home ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              heartBlack,
              width: 20,
              height: 20,
              colorBlendMode: BlendMode.srcIn,
              color: (_currentIndex == 1) ? Color(0XFF318531) : Colors.black,
            ),
            label: AppLocalizations.of(context)?.wishlist ?? 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              cartBlack,
              width: 20,
              height: 20,
              colorBlendMode: BlendMode.srcIn,
              color: (_currentIndex == 2) ? Color(0XFF318531) : Colors.black,
            ),
            label: AppLocalizations.of(context)?.cart ?? 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              personBlack,
              width: 20,
              height: 20,
              colorBlendMode: BlendMode.srcIn,
              color: (_currentIndex == 3) ? Color(0XFF318531) : Colors.black,
            ),
            label: AppLocalizations.of(context)?.profile ?? 'Profile',
          ),
        ],
      ),
    );
  }
}
