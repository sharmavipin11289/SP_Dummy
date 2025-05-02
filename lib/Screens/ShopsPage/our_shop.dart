import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonWidgets/shops_widget.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/ShopsPage/cubit/shops_cubit.dart';
import 'package:sanaa/Screens/ShopsPage/cubit/shops_state.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../HomePage/Model/shop_model.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  late ShopsCubit _cubit;
  List<ShopData> shops = [];
  bool _showLoader = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = BlocProvider.of<ShopsCubit>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This function will be called after the widget build is complete
      _getShops();
    });
  }

  _getShops() async {
    await _cubit.getShops();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          AppLocalizations.of(context)?.ourShops ?? 'Our Shops',
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<ShopsCubit, ShopsState>(builder: (context, state) {
        return SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // Two columns
                          crossAxisSpacing: 16, // Horizontal spacing
                          mainAxisSpacing: 20, // Vertical spacing
                          childAspectRatio: 0.75),
                      itemCount: shops.length, // Number of items in the grid
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            //_getDetails(shops[index].id ?? '');
                            NavigationService.navigateTo('/shopDetailPage', arguments: {'data': shops[index]});
                          },
                          child: ShopContainer(
                            shop: shops[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              if(shops.isEmpty && !_showLoader)
                Center(child: Text('Empty', style: FontStyles.getStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),),),
              if (_showLoader)
                Center(child: CircularProgressIndicator(),)
            ],
          ),
        ));
      }, listener: (context, state) {
        _showLoader = false;
        if (state is ShopsSuccess) {
          shops = state.shopsData;
        } else if (state is ShopsFailed) {
          print("Failed... to load shops: >> ${state.error}");
        } else if (state is ShopsLoading) {
          _showLoader = true;
        }
      }),
    );
  }
}
