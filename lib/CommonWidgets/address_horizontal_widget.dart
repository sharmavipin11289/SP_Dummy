import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../CommonFiles/text_style.dart';
import '../Navigation/navigation_service.dart';
import '../Screens/DeliveryAddressPage/Model/address_model.dart';
import '../Screens/DeliveryAddressPage/cubit/address_cubit.dart';
import '../Screens/DeliveryAddressPage/cubit/address_state.dart';

class AddressHorizontalWidget extends StatefulWidget {
  Function selectedAddress;
  AddressHorizontalWidget({super.key, required this.selectedAddress});

  @override
  State<AddressHorizontalWidget> createState() => _AddressHorizontalWidgetState();
}

class _AddressHorizontalWidgetState extends State<AddressHorizontalWidget> {
  late AddressCubit _addressCubit;

  List<AddressData> addresses = [];
  String _selectedAddressId = '';
  bool _showLoader =  false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addressCubit = BlocProvider.of<AddressCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAddresses();
    });
  }

  _getAddresses(){
    _addressCubit.getAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressCubit, AddressState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)?.deliveryAddress ?? 'Delivery Address',
                  style: FontStyles.getStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    NavigationService.navigateTo('/addDeliveryAddressPage').then((value) {
                      _addressCubit.getAddresses();
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context)?.addNew ?? 'Add New',
                    style: FontStyles.getStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF318531),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var address in addresses)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedAddressId = address.id ?? '';
                          });
                          widget.selectedAddress(_selectedAddressId);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: _selectedAddressId == address.id ? Colors.green : Colors.grey),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${address.firstName} ${address.lastName}',
                                style: FontStyles.getStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${address.address} - ${address.city}, ${address.zipCode} ${address.regionState} ${address.country}',
                                style: FontStyles.getStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }, listener: (context, state) {
      _showLoader = false;
      if (state is AddressLoading) {
        _showLoader = true;
      } else if (state is AddressSuccess) {
        state.response.sort((a, b) => (b.isMainAddress! ? 1 : 0).compareTo(a.isMainAddress! ? 1 : 0));
         addresses = state.response;
        _selectedAddressId = addresses.first.id ?? '';
        widget.selectedAddress(_selectedAddressId);
      }
    });
  }
}
