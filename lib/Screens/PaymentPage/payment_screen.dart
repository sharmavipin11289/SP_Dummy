import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/CommonFiles/Model/payment_method_model.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/Screens/PaymentPage/cubit/payment_page_cubit.dart';
import 'package:sanaa/Screens/PaymentPage/cubit/payment_page_state.dart';
import 'package:sanaa/Screens/PaymentPage/model/checkout_summary_model.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';
import '../../SharedPrefrence/shared_prefrence.dart';

class PaymentScreen extends StatefulWidget {
  String coupon = "";

  PaymentScreen({super.key, required this.coupon});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedIndex = 0;
  int selectedShippingIndex = 0;
  String selectedCurrency = '';
  late PaymentPageCubit _cubit;
  bool _showLoader = false;
  CheckoutSummaryData? summaryData;
  PaymentMethods? _selectedPaymentMethod;
  ShippingMethods? _selectedShippingMethod;

  TextEditingController _phoneTxtCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = BlocProvider.of<PaymentPageCubit>(context);
    selectedCurrency = SharedPreferencesHelper.getString('savedCurrency') ?? 'KES';
    _selectedPaymentMethod = paymentData?.paymentMethods?.first;
    _selectedShippingMethod = paymentData?.shippingMethods?.first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentPageCubit, PaymentPageState>(builder: (context, state) {
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
            AppLocalizations.of(context)?.payment ?? 'Payment',
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
            Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Payment Methods",
                          style: FontStyles.getStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      for (var i = 0; i < (paymentData?.paymentMethods?.length ?? 0); i++)
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                 _selectedPaymentMethod = paymentData!.paymentMethods![i];
                                setState(() {
                                  selectedIndex = i;
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                height: 68,
                                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      (selectedIndex == i) ? Icons.radio_button_checked_sharp : Icons.radio_button_off,
                                      color: (selectedIndex == i) ? Colors.green : Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Image.network(
                                      paymentData?.paymentMethods?[i].imageUrl ?? "",
                                      width: 64,
                                      height: 37,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      paymentData?.paymentMethods?[i].option ?? "",
                                      style: FontStyles.getStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if ((selectedIndex == i) && (paymentData?.paymentMethods?[i].requiresPhoneNumber ?? "").toLowerCase() == "yes")
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  "Enter your phone number below to pay with M-Pesa. You will receive instructions from M-Pesa to complete your payment.",
                                  style: FontStyles.getStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            if ((selectedIndex == i) && (paymentData?.paymentMethods?[i].requiresPhoneNumber ?? "").toLowerCase() == "yes")
                              SizedBox(
                                height: 8,
                              ),
                            if ((selectedIndex == i) && (paymentData?.paymentMethods?[i].requiresPhoneNumber ?? "").toLowerCase() == "yes")
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                  border: Border.all(width: 1),
                                ),
                                height: 60,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Text(
                                        "+254",
                                        style: FontStyles.getStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: _phoneTxtCtrl,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Shipping Methods",
                          style: FontStyles.getStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      for (var i = 0; i < (paymentData?.shippingMethods?.length ?? 0); i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedShippingIndex = i;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  (selectedShippingIndex == i) ? Icons.radio_button_checked_sharp : Icons.radio_button_off,
                                  color: (selectedShippingIndex == i) ? Colors.green : Colors.grey,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  paymentData?.shippingMethods?[i].name ?? '',
                                  style: FontStyles.getStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '$selectedCurrency ${paymentData?.shippingMethods?[i].cost ?? ''}',
                                  style: FontStyles.getStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if((_selectedPaymentMethod?.requiresPhoneNumber?.toLowerCase() == 'yes') && _phoneTxtCtrl.text.isEmpty) {
                          showToast("Phone number is required");
                        }else{
                          print("Code:: ${widget.coupon}");

                          final param = {
                            "currency": selectedCurrency,
                            if(widget.coupon.isNotEmpty) "coupon": '${widget.coupon}',
                          };

                          _cubit.getOrderSummary(param);
                        }
                      },
                      child: Text(
                        "Continue",
                        style: FontStyles.getStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_showLoader)
              Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      );
    }, listener: (context, state) {
      _showLoader = false;
      if (state is OrderSummeryLoading) {
        _showLoader = true;
      } else if (state is OrderSummeryLoaded) {
        if (state.summaryData != null) {
          summaryData = state.summaryData;

          final args = {
            'summaryData' : summaryData,
            'paymentMethod': _selectedPaymentMethod?.option ?? '',
            'shippingMethod': _selectedShippingMethod?.name ?? '',
            'phone': (_selectedPaymentMethod?.requiresPhoneNumber?.toLowerCase() == 'yes') ? _phoneTxtCtrl.text : ''
          };
          print(">>>>>>>>>>");
          print(args);
          NavigationService.navigateTo("/orderSummery",arguments: args);
        }
      } else if (state is OrderSummeryFailed) {
        print(">>>>>>>>>>> FFF");
        showToast(state.error);
      }
    });
  }
}
