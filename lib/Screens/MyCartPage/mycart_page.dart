import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/CommonFiles/cubit/common_cubit.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/MyCartPage/Model/cart_summary_model.dart';
import 'package:sanaa/Screens/MyCartPage/cubit/cart_cubit.dart';
import 'package:sanaa/Screens/MyCartPage/cubit/cart_state.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../SharedPrefrence/shared_prefrence.dart';
import 'Model/cart_model.dart';

class MyCartPage extends StatefulWidget {
  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  late CartCubit _cartCubit;
  bool _showLoader = false;
  List<CartData> _products = [];
  CartSummaryData? summaryData;
  TextEditingController _couponTxtController = TextEditingController();
  bool _isCouponApplied = false;
  String appliedCoupon = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cartCubit = BlocProvider.of<CartCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCartData();
    });
  }

  _getCartData() async {
    await _cartCubit.getCartProducts();
  }

  _getSummary() async {
    final param = {
      "currency": SharedPreferencesHelper.getString('savedCurrency') ?? 'KES',
      if(_isCouponApplied && appliedCoupon.isNotEmpty) "coupon": appliedCoupon,
    };

    _cartCubit.getOrderSummary(param);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(''),
          ),
          title: Text(
            AppLocalizations.of(context)?.myCart ?? 'My Cart',
            style: FontStyles.getStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: (_products.isEmpty && !_showLoader)
                          ? Center(
                              child: Text(AppLocalizations.of(context)?.emptyCart ?? 'Empty Cart!!'),
                            )
                          : ListView(
                              children: [
                                for (var product in _products) _buildCartItem(product: product),
                                SizedBox(
                                  height: 20,
                                ),
                                if (_products.isNotEmpty) _buildCouponSection(context),
                                SizedBox(
                                  height: 20,
                                ),
                                if (summaryData != null) _buildCartTotals(context),
                                if (summaryData != null)
                                  SizedBox(
                                    height: 30,
                                  ),
                                if (_products.isNotEmpty)
                                  InkWell(
                                    onTap: () async {

                                      await context.read<CommonCubit>().checkoutInitiate();
                                      if(paymentData != null) {
                                        //NavigationService.navigateTo("/paymentScreen",arguments: (_isCouponApplied) ? _couponTxtController.text : '');
                                        _getSummary();
                                      } else {
                                        showToast("Unable to initiate payment method. Please try later!");
                                      }
                                      /*await context.read<CommonCubit>().checkoutSummary(_couponTxtController.text, _products.first.currency ?? '').then((isSuccess) {
                                        if (isSuccess) {
                                        } else {
                                          print("Failed to initiate checkout");
                                        }
                                      });*/
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 26),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.black,
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)?.checkout ?? 'Checkout',
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
                  ],
                ),
              ),
              if (_showLoader)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      );
    }, listener: (context, state) {
      _showLoader = false;

      if (state is CartLoading) {
        print("Show:::::");
        _showLoader = true;
      } else if (state is CartGetFailed) {
        showToast(state.error);
      } else if (state is CartGetSuccess) {
        if (state.products.length > 0) {
          _products = state.products;
          _cartCubit.getCartSummary(_couponTxtController.text, _products.first.currency ?? '');
        } else {
          _products = [];
        }
      } else if (state is CartSummarySuccess) {
        print("Succeess>>>>>>");
        summaryData = state.summaryData;
        appliedCoupon = _couponTxtController.text;
        _couponTxtController.text = '';

      } else if (state is CouponSuccess) {
        NavigationService.navigateTo(
          '/couponPage',
          arguments: {'coupons': state.coupons,'selectedCode': summaryData?.coupon_code ?? ''},
        ).then((result) {
          print(result);
          if(result is String && result == 'remove') {
            _couponTxtController.text = '';
            appliedCoupon = '';
            _isCouponApplied = true;
            _cartCubit.getCartSummary(_couponTxtController.text, _products.first.currency ?? '');
          }else if (result != null) {
            _couponTxtController.text = result as String;
            _isCouponApplied = false;
          }
        });
      } else if (state is CartSummaryFailed) {

        showToast(state.error);
      } else if (state is OrderSummeryLoading) {
        _showLoader = true;
      } else if (state is OrderSummeryLoaded) {
        if (state.summaryData != null) {
          final args = {
            'summaryData' : state.summaryData,
            /*'paymentMethod': _selectedPaymentMethod?.option ?? '',*/
            'shippingMethod': 'EXPRESS_SHIPPING',
            /*'phone': (_selectedPaymentMethod?.requiresPhoneNumber?.toLowerCase() == 'yes') ? _phoneTxtCtrl.text : ''*/
          };
          print(">>>>>>>>>>");
          print(args);
          NavigationService.navigateTo("/orderSummery",arguments: args);
        }
      } else if (state is OrderSummeryFailed) {

        showToast(state.error);
      }
    });
  }

  Widget _buildCartItem({
    required CartData product,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 107,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.imageUrl ?? dummyImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    product.productName ?? '-',
                    maxLines: 2,
                    style: FontStyles.getStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Size: ${product.sizeVariantName ?? '-'}  Color: ${product.colorVariantName ?? '-'}',
                    style: FontStyles.getStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF5A5A5A),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${product.currency ?? 'KES'} ${product.total?.toStringAsFixed(2) ?? '-'}',
                    style: FontStyles.getStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF318531),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          //decrease quantitu
                          final qty = (product.quantity ?? 0) - 1;
                          if (qty >= 1) {
                            final param = {"quantity": '$qty'};
                            _cartCubit.updateCart(product.id ?? '', param);
                          }
                        },
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(width: 1, color: Color(0xFFE7E7E7)),
                          ),
                          child: Center(
                              child: Icon(
                            Icons.remove,
                            size: 15,
                          )),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        '${product.quantity}',
                        style: FontStyles.getStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          //add
                          final qty = (product.quantity ?? 0) + 1;
                          if (qty >= 1) {
                            final param = {"quantity": '$qty'};
                            _cartCubit.updateCart(product.id ?? '', param);
                          }
                        },
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(width: 1, color: Color(0xFFE7E7E7)),
                          ),
                          child: Center(
                              child: Icon(
                            Icons.add,
                            size: 15,
                          )),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _cartCubit.deleteCart(product.id ?? '');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: Color(0xFFC1DAC1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 8),
            child: Text(
              AppLocalizations.of(context)?.couponCode ?? 'Coupon Code',
              style: FontStyles.getStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(
            color: Color(0xFFC1DAC1),
          ),
          SizedBox(
            height: 19,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _couponTxtController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)?.enterCode ?? 'Enter Code',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Color(0xFFC1DAC1), width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () async {
                  _isCouponApplied = true;
                  _cartCubit.getCartSummary(_couponTxtController.text, _products.first.currency ?? '');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 26),
                  height: 39,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xFF318531),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)?.applyCoupon ?? 'APPLY COUPON',
                      style: FontStyles.getStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _cartCubit.getCoupons();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 26),
                  height: 39,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xFFC1DAC1), width: 1)),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)?.checkOffers ?? 'CHECK OFFERS',
                      style: FontStyles.getStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _buildCartTotals(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: Color(0xFFC1DAC1)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.cartTotal ?? 'Card Total',
              style: FontStyles.getStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)?.subTotal ?? 'Sub-total',
                  style: FontStyles.getStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '${_products.first.currency ?? ''} ${summaryData!.subTotalPrice?.toStringAsFixed(2)}',
                  style: FontStyles.getStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            if ((summaryData?.discountAmount ?? 0.00) > 0.00)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context)?.discount ?? 'Discount'} ${appliedCoupon.isNotEmpty ? '(${appliedCoupon} ${AppLocalizations.of(context)?.applied ?? 'Applied'})' : ''}",
                    style: FontStyles.getStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "${_products.first.currency ?? ''} ${summaryData?.discountAmount?.toStringAsFixed(2) ?? '0.00'}",
                    style: FontStyles.getStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)?.tax ?? 'Tax',
                  style: FontStyles.getStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '${_products.first.currency ?? ''} ${summaryData?.totalTaxAmount?.toStringAsFixed(2)}',
                  style: FontStyles.getStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Divider(
              color: Color(0xFFC1DAC1),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)?.total ?? 'Total',
                  style: FontStyles.getStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '${_products.first.currency ?? ''} ${summaryData?.totalPrice?.toStringAsFixed(2)}',
                  style: FontStyles.getStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
