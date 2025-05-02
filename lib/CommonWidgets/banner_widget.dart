import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sanaa/Screens/HomePage/Model/banner_model.dart';

import '../CommonFiles/common_variables.dart';

class BannerWidget extends StatefulWidget {
  List<BannerData> banners;
  double paddingHorizontal;

  BannerWidget({super.key, this.paddingHorizontal = 20, required this.banners});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late Timer _timer;
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.9,
    );

    _timer = Timer.periodic(Duration(seconds: 3), _autoScroll);
  }


  void _autoScroll(Timer timer) {
    print("inside auto scroll");
    if (_currentPage < widget.banners.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }



  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 164,
      child: PageView(
          controller: _pageController,
          children: [
            for (var i = 0; i < widget.banners.length; i++)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.paddingHorizontal),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 164,
                    child: Image.network(
                      widget.banners[i].imageUrl ?? dummyImageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          ]),
    );
  }


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
