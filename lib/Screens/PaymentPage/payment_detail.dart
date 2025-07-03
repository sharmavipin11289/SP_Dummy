/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/CommonWidgets/address_horizontal_widget.dart';
import 'package:sanaa/Screens/OrderDetails/Model/place_order_model.dart';
import 'package:sanaa/Screens/PaymentPage/cubit/payment_page_cubit.dart';
import 'package:sanaa/Screens/PaymentPage/cubit/payment_page_state.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentDetail extends StatefulWidget {
  PlaceOrderData orderData;
  PaymentDetail({super.key, required this.orderData});

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  bool _showLoader = false;
  late PaymentPageCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = BlocProvider.of<PaymentPageCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentPageCubit, PaymentPageState>(builder: (context,state) {
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
            AppLocalizations.of(context)?.paymentDetail ?? 'Payment Detail',
            style: FontStyles.getStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView(
          children: [
            SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)?.paymentMethod ?? 'Payment Method'}' */
/*"${AppLocalizations.of(context)?.discount ?? 'Discount'} ${_couponTxtController.text.isNotEmpty ? '(${_couponTxtController.text} ${AppLocalizations.of(context)?.applied ?? 'Applied'})' : ''}"*//*
,
                    style: FontStyles.getStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${widget.orderData.paymentMethod}' ,
                    style: FontStyles.getStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)?.orderNo ?? 'Order No.'}' */
/*"${AppLocalizations.of(context)?.discount ?? 'Discount'} ${_couponTxtController.text.isNotEmpty ? '(${_couponTxtController.text} ${AppLocalizations.of(context)?.applied ?? 'Applied'})' : ''}"*//*
,
                    style: FontStyles.getStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${widget.orderData.orderNumber}' */
/*"${summaryData?.discountAmount?.toStringAsFixed(2) ?? '0.00'}"*//*
,
                    style: FontStyles.getStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                AppLocalizations.of(context)?.paymentInstructions ?? "Payment Instructions",
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
                enabled: false,
                maxLines: 14, // Sets the number of lines
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
                  hintText: '''
1. Go to Pesalink menu
2. Select Pay to Account
3. Enter account number: undefined (where XXXXX Qlick Solutions Limited Customer Account Number)
4. Enter account name: QLICK SOLUTIONS LIMITED
5. Enter amount
6. Select I&M Bank as the beneficiary bank
7. Under remarks indicate: your Qlick Solutions Limited Customer Account Number
8. Submit Payment
9. You will receive a Pesalink confirmation SMS
                ''',
                  // Optional: placeholder text
                  hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal,fontSize: 16),
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
                              '${widget.orderData.checkoutSummaryData?.items?.first.currency} ${widget.orderData.checkoutSummaryData?.subTotalAmount}',
                              style: FontStyles.getStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if((widget.orderData.checkoutSummaryData?.shippingAmount ?? 0) > 0)
                          SizedBox(
                            height: 8,
                          ),
                        if((widget.orderData.checkoutSummaryData?.shippingAmount ?? 0) > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)?.shipping ?? 'Shipping'}' */
/*"${AppLocalizations.of(context)?.discount ?? 'Discount'} ${_couponTxtController.text.isNotEmpty ? '(${_couponTxtController.text} ${AppLocalizations.of(context)?.applied ?? 'Applied'})' : ''}"*//*
,
                                style: FontStyles.getStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '${widget.orderData.checkoutSummaryData?.items?.first.currency} ${widget.orderData.checkoutSummaryData?.shippingAmount}',
                                style: FontStyles.getStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                        if((widget.orderData.checkoutSummaryData?.discountAmount ?? 0) > 0)
                          SizedBox(
                            height: 8,
                          ),
                        if((widget.orderData.checkoutSummaryData?.discountAmount ?? 0) > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)?.discount ?? 'Discount'}' */
/*"${AppLocalizations.of(context)?.discount ?? 'Discount'} ${_couponTxtController.text.isNotEmpty ? '(${_couponTxtController.text} ${AppLocalizations.of(context)?.applied ?? 'Applied'})' : ''}"*//*
,
                                style: FontStyles.getStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '${widget.orderData.checkoutSummaryData?.items?.first.currency} ${widget.orderData.checkoutSummaryData?.discountAmount}',
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
                              '${widget.orderData.checkoutSummaryData?.items?.first.currency} ${widget.orderData.checkoutSummaryData?.totalTaxAmount}',
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
                                '${widget.orderData.checkoutSummaryData?.items?.first.currency} ${widget.orderData.checkoutSummaryData?.totalAmount}',
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
            if (_showLoader)
              Center(
                child: CircularProgressIndicator(),
              ),
            if (!_showLoader)
            InkWell(
              onTap: () async {
                final param = {
                  "order_id": widget.orderData.orderId,
                  "transaction_id": widget.orderData.transactionId
                };
                await _cubit.confirmOrder(param);
                //await context.read<CommonCubit>().checkoutInitiate();
                */
/* await context.read<CommonCubit>().checkoutSummary(_couponTxtController.text, _products.first.currency ?? '').then((isSuccess) {
                                        if (isSuccess) {
                                        } else {
                                          print("Failed to initiate checkout");
                                        }
                                      });*//*

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
                    AppLocalizations.of(context)?.confirmPayment ?? 'Confirm Payment',
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
      );
    }, listener: (context,state){
      _showLoader = false;
      if (state is ConfirmPaymentLoading) {
        _showLoader = true;
      }else if(state is ConfirmPaymentSuccess) {
        NavigationService.navigateAndClearStack("/orderConfirmScreen");
      }else if(state is ConfirmPaymentFailed) {
          showToast(state.error);
      }
    });

  }
}
*/
