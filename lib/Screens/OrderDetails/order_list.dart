import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/OrderDetails/cubit/order_cubit.dart';
import 'package:sanaa/Screens/OrderDetails/cubit/order_state.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../main.dart';
import 'Model/order_model.dart';

class OrderList extends StatefulWidget {
  bool isFromOrdferConfirmationScreen;
  OrderList({super.key, required this.isFromOrdferConfirmationScreen});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late OrderCubit _cubit;
  List<Order> _orders = [];
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = BlocProvider.of<OrderCubit>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getOrders();
    });
  }

  _getOrders() async {
    await _cubit.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            if(widget.isFromOrdferConfirmationScreen) {
              NavigationService.navigateAndClearStack('/mainPage');
            }else {
              NavigationService.goBack();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(back),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)?.myOrders ?? 'My Orders',
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<OrderCubit, OrderState>(builder: (context, state) {
        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return GestureDetector(
                  onTap: () {
                    NavigationService.navigateTo('/orderDetails', arguments: _orders[index].id);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                            color: Color(0xFFC1DAC1),
                          ),
                          padding: const EdgeInsets.all(12),
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)?.orderID ?? 'ORDER ID :'} ${_orders[index].orderNumber ?? ''}",
                                style: FontStyles.getStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Icon(Icons.arrow_forward, color: Colors.green),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)?.date ?? "DATE :",
                                    style: FontStyles.getStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _orders[index].date ?? '',
                                    style: FontStyles.getStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)?.status ?? "STATUS :",
                                    style: FontStyles.getStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _orders[index].status ?? 'Unknown',
                                    style: FontStyles.getStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: ((_orders[index].status?.toLowerCase() ?? "") == "PROCESSING".toLowerCase()) ? Colors.yellow.shade700 : Colors.green, //Color(int.parse(order['statusColor']!)),
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
                );
              },
            ),
            if (!networkStatus.isOnline)
              Center(
                child: Text(
                  AppLocalizations.of(context)?.noInternetConnection ?? "No internet connection...",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            if (_orders.isEmpty)
              Center(
                child: Text(AppLocalizations.of(context)?.noDataFound ?? 'No Data Found'),
              )
          ],
        );
      }, listener: (context, state) {
        _isLoading = false;
        if (state is OrdersSuccess) {
          _orders = state.orders;
        } else if (state is Ordersloading) {
          _isLoading = true;
        }
      }),
    );
  }
}
