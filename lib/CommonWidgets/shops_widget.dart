import 'package:flutter/material.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/HomePage/Model/shop_model.dart';
import '../CommonFiles/text_style.dart';

class ShopsWidget extends StatefulWidget {
  List<ShopData> shops;
  ShopsWidget({super.key, required this.shops});

  @override
  State<ShopsWidget> createState() => _ShopsWidgetState();
}

class _ShopsWidgetState extends State<ShopsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.shops ?? 'Shops',
                style: FontStyles.getStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: (){
                  NavigationService.navigateTo('/shopsPage');
                },
                child: Text(
                  AppLocalizations.of(context)?.seeAll ?? 'See All',
                  style: FontStyles.getStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF318531),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14,),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for(var shop in widget.shops)
                  ShopContainer(shop: shop,),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShopContainer extends StatelessWidget {
  ShopData shop;
  ShopContainer({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        NavigationService.navigateTo('/shopDetailPage', arguments: {'data': shop});
      },
      child: Container(
        margin: EdgeInsets.only(right: 15,),
        color: Colors.transparent,
        width: 66,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 66,height: 66,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    shop.businessLogoUrl ?? dummyImageUrl,
                    width: 66,
                    height: 66,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                shop.businessName ?? shop.name ?? '-',
                style: FontStyles.getStyle(fontSize: 10, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
