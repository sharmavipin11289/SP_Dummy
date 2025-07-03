import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/OrderDetails/Model/order_detail_model.dart';
import 'package:sanaa/Screens/OrderDetails/cubit/order_cubit.dart';
import 'package:sanaa/Screens/OrderDetails/cubit/order_state.dart';
import 'package:xml/xml.dart';
import '../../CommonFiles/text_style.dart';
import '../../SharedPrefrence/shared_prefrence.dart';
import '../../main.dart';

class OrderDetails extends StatefulWidget {
  String orderID;

  OrderDetails({super.key, required this.orderID});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late OrderCubit _cubit;
  OrderDetailData? orderData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = BlocProvider.of<OrderCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getOrderDetail();
    });
  }

  _getOrderDetail() async {
    await _cubit.getOrderDetails(widget.orderID);
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
          AppLocalizations.of(context)?.orderDetails ?? 'Order Details',
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Info
                    _buildOrderHeader(),

                    Divider(),

                    // Product List
                    _buildProductSection(),

                    Divider(),

                    // Price Details
                    _buildPriceDetails(),

                    Divider(),

                    // Delivery Address
                    _buildDeliveryAddress(),

                    Divider(),

                    // Order Notes
                    _buildOrderNotes(),
                  ],
                ),
              ),
              if (!networkStatus.isOnline)
                Center(
                  child: Text(
                    AppLocalizations.of(context)?.noInternetConnection ?? "No internet connection...",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
            ],
          );
        },
        listener: (context, state) {
          if (state is OrderDetailSuccess) {
            orderData = state.orderData;
          }
        },
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                orderData?.orderDetails?.number ?? '#',
                style: FontStyles.getStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              const Text(
                '',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            '${orderData?.orderDetails?.totalProducts ?? ''} ${AppLocalizations.of(context)?.productsOrderPlacedOn ?? 'Products • Order Placed on'} ${orderData?.orderDetails?.date ?? '-'} ${AppLocalizations.of(context)?.at ?? 'at'} ${orderData?.orderDetails?.time ?? '-'} ',
            style: FontStyles.getStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)?.products ?? 'Products'} (${orderData?.orderDetails?.totalProducts ?? '-'})',
                style: FontStyles.getStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${orderData?.orderDetails?.currency ?? ''} ${orderData?.orderDetails?.totalAmount ?? ''}',
                style: FontStyles.getStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF318531),
                ),
              ),
            ],
          ),
        ),
        for (var i = 0; i < (orderData?.orderItems?.length ?? 0); i++) _productItem(orderData!.orderItems![i]),
      ],
    );
  }

  Widget _productItem(OrderItems orderItem) {
    return InkWell(
      onTap: () {
        print(orderItem.status);
        if((orderItem.status ?? '').toLowerCase() == 'delivered'){
          final param = {
            "status": orderItem.status ?? '',
            "tracking_number": orderData?.orderDetails?.number ?? '',
          };
          //_cubit.getInvoiceFor(orderData?.orderDetails?.id ?? '', orderItem.id ?? '', param);
          _downloadInvoice(orderData?.orderDetails?.id ?? '', orderItem.id ?? '', param);
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              width: 80,
              height: 80,
              child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(orderItem.product?.image ?? dummyImageUrl, fit: BoxFit.cover)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          orderItem.product?.name ?? '',
                          maxLines: 3,
                          style: FontStyles.getStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      if (orderItem.status?.toLowerCase() == "delivered")
                        Image.asset(
                          taskList,
                          width: 20,
                          height: 20,
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Size: ${orderItem.product?.sizeVariantName ?? ''}   Color: ${orderItem.product?.colorVariantName ?? ''}   Quantity: x${orderItem.quantity}',
                    style: FontStyles.getStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${orderData?.orderDetails?.currency ?? ''} ${orderItem.totalAmount}',
                        style: FontStyles.getStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF318531),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xFFE0E0E0)),
                        child: Text(
                          orderItem.status ?? '',
                          style: FontStyles.getStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)?.priceDetail ?? 'Price Details'} (${orderData?.orderDetails?.totalProducts})',
            style: FontStyles.getStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          _priceRow(AppLocalizations.of(context)?.subTotal ?? 'Sub Total', '${orderData?.orderDetails?.currency ?? ''} ${orderData?.orderDetails?.subtotalAmount ?? ''}'),
          _priceRow(AppLocalizations.of(context)?.discount ?? 'Discount', '${orderData?.orderDetails?.currency ?? ''} ${orderData?.orderDetails?.discountAmount ?? ''}'),
          _priceRow(AppLocalizations.of(context)?.tax ?? 'Tax', '${orderData?.orderDetails?.currency ?? ''} ${orderData?.orderDetails?.taxAmount ?? ''}'),
          _priceRow(AppLocalizations.of(context)?.shipping ?? 'Shipping', '${orderData?.orderDetails?.currency ?? ''} ${orderData?.orderDetails?.shipping ?? ''}'),
          Divider(),
          _priceRow(AppLocalizations.of(context)?.grandTotal ?? 'Grand Total', '${orderData?.orderDetails?.currency ?? ''} ${orderData?.orderDetails?.totalAmount ?? ''}', isBold: true, color: Color(0xFF318531)),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: FontStyles.getStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: color ?? Colors.black,
            ),
          ),
          Text(
            value,
            style: FontStyles.getStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)?.deliveryAddress ?? 'Delivery Address',
            style: FontStyles.getStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                locationCircle,
                width: 30,
                height: 30,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderData?.deliveryAddress?.name ?? '',
                      style: FontStyles.getStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      orderData?.deliveryAddress?.address ?? '',
                      style: FontStyles.getStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Phone Number: ${orderData?.deliveryAddress?.phoneNumber ?? ''}',
                      style: FontStyles.getStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Email: ${orderData?.deliveryAddress?.email ?? ''}',
                      style: FontStyles.getStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderNotes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)?.orderNotes ?? 'Order Notes',
            style: FontStyles.getStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${orderData?.deliveryAddress?.deliveryInstruction ?? ''}',
            style: FontStyles.getStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  _downloadInvoice(String orderId, String orderItemId, Map<String, dynamic> param) async {
    final dio = Dio();
    print('https://sanna-api.udaipurhiring.com/api/v1/orders/$orderId/order-items/$orderItemId/invoice');
    print(param);
    try {
      final bearerToken = await SharedPreferencesHelper.getString('token');
      print("bearerToken:: $bearerToken");

      Response response = await dio.get(
        'https://sanna-api.udaipurhiring.com/api/v1/orders/$orderId/order-items/$orderItemId/invoice',
        queryParameters: param,
        options: Options(
            responseType: ResponseType.bytes,
          headers: {
            'Accept': 'application/pdf',
            if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
          },
        ),
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        final contentType = response.headers['content-type']?.first ?? 'unknown';
        print('Content-Type: $contentType');

        if (contentType.contains('application/pdf')) {
          // Save the PDF to a file
          final bytes = response.data as List<int>; // ResponseType.bytes gives us a Uint8List
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/invoice_$orderId$orderItemId.pdf');

          await file.writeAsBytes(bytes);
          print('PDF saved to: ${file.path}');

          // Open the PDF
          final result = await OpenFile.open(file.path);
          if (result.type == ResultType.done) {
            print('PDF opened successfully');
          } else {
            showToast('${result.message}');
          }
        } else {
          print('Expected PDF, but received: $contentType');
          showToast('Expected PDF');
        }
      } else {
        showToast(response.data);
      }
    } catch (e) {
      print('Error occurred: $e');
      showToast("${e.toString()}");
    }
  }
}
