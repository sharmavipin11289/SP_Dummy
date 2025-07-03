import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/CommonWidgets/address_horizontal_widget.dart';
import 'package:sanaa/Screens/OrderDetails/Model/place_order_model.dart';
import 'package:sanaa/Screens/OrderDetails/cubit/order_cubit.dart';
import 'package:sanaa/Screens/OrderDetails/cubit/order_state.dart';
import 'package:sanaa/Screens/PaymentPage/model/checkout_summary_model.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../SharedPrefrence/shared_prefrence.dart';

class OrderSummery extends StatefulWidget {
  Map<String, dynamic> args;

  OrderSummery({super.key, required this.args});

  @override
  State<OrderSummery> createState() => _OrderSummeryState();
}

class _OrderSummeryState extends State<OrderSummery> {
  List<CheckoutItem> items = [];
  String _selectedAddressID = '';
  late CheckoutSummaryData summaryData;
  TextEditingController _orderNoteCtrl = TextEditingController();
  bool _showLoader = false;

  late OrderCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    print(widget.args);
    _cubit = BlocProvider.of<OrderCubit>(context);
    super.initState();
    summaryData = widget.args['summaryData'] as CheckoutSummaryData;
    items = summaryData.items ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(builder: (context, state) {
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
            AppLocalizations.of(context)?.orderSummary ?? 'Order Summary',
            style: FontStyles.getStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                AddressHorizontalWidget(
                  selectedAddress: (addressID) {
                    _selectedAddressID = addressID;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    AppLocalizations.of(context)?.orderNotesOptional ?? "Order Notes (Optional)",
                    style: FontStyles.getStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _orderNoteCtrl,
                    maxLines: 4, // Sets the number of lines
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        // Creates a border around the TextField
                        borderRadius: BorderRadius.circular(12.0), // Optional: rounded corners
                        borderSide: const BorderSide(
                          color: Colors.grey, // Border color
                          width: 1.0, // Border thickness
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        // Border when not focused
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.green.shade300,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Border when focused
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.green.shade300,
                          width: 1.0,
                        ),
                      ),
                      hintText: AppLocalizations.of(context)?.notesAboutYourOrder ??  'Notes about your order',
                      // Optional: placeholder text
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.green.shade300,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          AppLocalizations.of(context)?.orderSummary ?? "Order Summary",
                          style: FontStyles.getStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.green,
                      ),
                      for (var i = 0; i < items.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: Image.network(
                                    items[i].imageUrl ?? dummyImageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                // Added Expanded to allow text to wrap within available space
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${items[i].productName}',
                                      style: FontStyles.getStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 10, // Limits to 2 lines, adjust as needed
                                      overflow: TextOverflow.ellipsis, // Adds ellipsis if text exceeds maxLines
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${items[i].quantity} ",
                                          style: FontStyles.getStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          "X ${items[i].currency}",
                                          style: FontStyles.getStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0XFF318531),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
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
                                  '${items.first.currency} ${summaryData.subTotalAmount}',
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
                                  '${AppLocalizations.of(context)?.shipping ?? 'Shipping'}' /*"${AppLocalizations.of(context)?.discount ?? 'Discount'} ${_couponTxtController.text.isNotEmpty ? '(${_couponTxtController.text} ${AppLocalizations.of(context)?.applied ?? 'Applied'})' : ''}"*/,
                                  style: FontStyles.getStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${items.first.currency} ${summaryData.shippingAmount}' /*"${summaryData?.discountAmount?.toStringAsFixed(2) ?? '0.00'}"*/,
                                  style: FontStyles.getStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            if (summaryData.couponCode != null)
                              SizedBox(
                                height: 8,
                              ),
                            if (summaryData.couponCode != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)?.discount ?? 'Discount'} ${summaryData.couponCode} ${AppLocalizations.of(context)?.applied ?? 'Applied'}' /*"${AppLocalizations.of(context)?.discount ?? 'Discount'} ${_couponTxtController.text.isNotEmpty ? '(${_couponTxtController.text} ${AppLocalizations.of(context)?.applied ?? 'Applied'})' : ''}"*/,
                                    style: FontStyles.getStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '${items.first.currency} ${summaryData.discountAmount}',
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
                                  '${summaryData.items?.first.currency} ${summaryData.totalTaxAmount?.toStringAsFixed(2)}',
                                  style: FontStyles.getStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)?.total ?? 'Total',
                                    style: FontStyles.getStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${summaryData.items?.first.currency} ${summaryData.totalAmount?.toStringAsFixed(2)}',
                                    style: FontStyles.getStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    final param = {
                      "address_id": _selectedAddressID,
                      /*"payment_method": widget.args['paymentMethod'] as String,*/
                     /* if ((widget.args['phone'] as String).isNotEmpty) "phone_number": "712345679",*/
                      "shipping_method": widget.args['shippingMethod'] as String,
                      "currency": SharedPreferencesHelper.getString('savedCurrency') ?? 'KES',
                    if (_orderNoteCtrl.text.trim().length > 1) "delivery_instruction": _orderNoteCtrl.text,
                    };
                      await _cubit.placeOrder(param);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    padding: EdgeInsets.symmetric(horizontal: 26),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)?.placeOrder ?? 'Place Order',
                        style: FontStyles.getStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            if (_showLoader)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      );
    }, listener: (context, state) {
      _showLoader = false;
      if (state is POLoading) {
        _showLoader = true;
      } else if (state is POFailed) {
        print(">>>>>>>>");
        showToast(state.error);
      } else if (state is POSuccess) {
        if(state.orderData != null) {
          PlaceOrderData? orderData = state.orderData;
          print(orderData?.payment_url);
          NavigationService.navigateTo('/webViewScreen',arguments: orderData?.payment_url);
         /* orderData?.checkoutSummaryData = summaryData;
          orderData?.paymentMethod =  widget.args['paymentMethod'] as String;*/
          //debugPrint('>>>>>>>>>>>>>>${summaryData.discountAmount ?? 0.0}');
          //NavigationService.navigateTo('/paymentDetail',arguments: state.orderData);
        }
      }
    });
  }
}
