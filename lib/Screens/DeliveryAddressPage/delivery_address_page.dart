import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/Model/address_model.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/cubit/address_cubit.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/cubit/address_state.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';

class DeliveryAddressPage extends StatefulWidget {
  const DeliveryAddressPage({super.key});

  @override
  State<DeliveryAddressPage> createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {

  late AddressCubit _addressCubit;
  List<AddressData> addresses = [];
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
          AppLocalizations.of(context)?.deliveryAddress ?? 'Delivery Address',
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocConsumer<AddressCubit,AddressState>(builder: (context,state){
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
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      for(var address in addresses)
                        InkWell(
                          onTap: (){
                            NavigationService.navigateTo('/updateDeliveryAddress',arguments: address).then((value) {
                              _addressCubit.getAddresses();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom:10),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: (address.isMainAddress ?? false) ? Colors.green : Colors.grey),
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
                    ],
                  ),
                ),
              ],
            ),
          );
        }, listener: (context,state){
          _showLoader = false;
          if(state is AddressLoading) {
            _showLoader = true;
          }else if (state is AddressSuccess) {
            addresses = state.response;
          }
        })
      ),
    );
  }
}
