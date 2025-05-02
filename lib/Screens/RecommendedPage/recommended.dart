import 'package:flutter/material.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonWidgets/product_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({super.key});

  @override
  State<RecommendedPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            NavigationService.goBack();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(back),
          ),
        ),

        title: Text(
          AppLocalizations.of(context)?.recommended ?? 'Recommended',
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 20, // Horizontal spacing
                  mainAxisSpacing: 20, // Vertical spacing
                  childAspectRatio: 0.85
                ),
                itemCount: 20, // Number of items in the grid
                itemBuilder: (context, index) {
                  return ProductCard(product: ProductData(),);
                },

              ),
            ),
          ],
        ),
      )),
    );
  }
}


