import 'package:flutter/material.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/CommonFiles/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/HomePage/Model/main_category_model.dart';

import '../Navigation/navigation_service.dart';

class CategoryWidget extends StatefulWidget {
  List<MainCategoryData> categoryData;

  CategoryWidget({super.key, required this.categoryData});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppLocalizations.of(context)?.categories ?? 'Categories',
              style: FontStyles.getStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
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
                  for (var category in widget.categoryData)
                    InkWell(
                        onTap: () {
                          final args = {
                            'title' : category.name,
                            'offerId': null,
                            'category':category.name,
                            'vendorId': null,
                          };
                          NavigationService.navigateTo('/excitingOffer',arguments: args);
                        },
                        child: CategoryContainer(
                          category: category,
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  MainCategoryData category;

  CategoryContainer({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 12,
      ),
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(33),
              child: SizedBox(
                width: 66,
                height: 66,
                child: Image.network(
                  category.imageUrl ?? dummyImageUrl,
                  width: 66,
                  height: 66,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              category.name ?? '',
              style: FontStyles.getStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
