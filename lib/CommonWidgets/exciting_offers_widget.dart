import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/Screens/HomePage/Model/offers_model.dart';
import '../CommonFiles/text_style.dart';
import '../Navigation/navigation_service.dart';

class ExcitingOffersWidget extends StatefulWidget {
  List<OfferData> offers;

  ExcitingOffersWidget({super.key, required this.offers});

  @override
  State<ExcitingOffersWidget> createState() => _ExcitingOffersWidgetState();
}

class _ExcitingOffersWidgetState extends State<ExcitingOffersWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.excitingOffer ?? 'Exciting Offers',
                style: FontStyles.getStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  final args = {
                    'title': AppLocalizations.of(context)?.excitingOffer ?? 'Exciting Offer',
                    'offerId': widget.offers.first.id ?? '',
                    'view': 'exciting-offers'
                  };
                  NavigationService.navigateTo('/excitingOffer', arguments: args);
                },
                child: Text(
                 '',// AppLocalizations.of(context)?.seeAll ?? 'See All',
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
        SizedBox(
          height: 14,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var offer in widget.offers)
                  InkWell(
                    onTap: () {
                      print(offer.id);
                      final args = {
                        'title' : AppLocalizations.of(context)?.excitingOffer ?? 'Exciting offers',
                        'offerId': offer.id ?? '',
                        'category':null,
                        'vendorId': null,
                        'view': 'exciting-offers'
                      };
                      NavigationService.navigateTo('/excitingOffer',arguments: args);
                    },
                    child: SizedBox(
                      width: 229,
                      height: 122,
                      child: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            offer.imageUrl ?? dummyImageUrl,
                            width: 229,
                            height: 122,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
