import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/Model/address_model.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/cubit/address_cubit.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/cubit/address_state.dart';
import 'package:sanaa/Screens/SignUpPage/cubit/signup_state.dart';
import '../../CommonFiles/common_function.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';
import '../SignUpPage/Model/country_model.dart';
import 'Model/city_model.dart';
import 'Model/state_model.dart';

class UpdateDeliveryAddress extends StatefulWidget {
 AddressData addressData;
 UpdateDeliveryAddress({super.key, required this.addressData});

  @override
  State<UpdateDeliveryAddress> createState() => _UpdateDeliveryAddressState();
}

class _UpdateDeliveryAddressState extends State<UpdateDeliveryAddress> {
  bool _isSwitched = false;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController stateF = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  String selectedCountry = '';
  String selectedState = '';
  String selectedCity = '';

  late AddressCubit _cubit;
  bool _showLoader = false;

//show country
  void _showCountries(BuildContext context, List<CountryData> countries) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)?.selectCountry ?? 'Choose Country',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                for (var cntry in countries)
                  RadioListTile<String>(
                    title: Text(cntry.name ?? ''),
                    value: cntry.name ?? '',
                    groupValue: selectedCountry,
                    onChanged: (value) {
                      setState(() {
                        print("Country:::: $value");
                        selectedCountry = value!;
                        country.text = selectedCountry;
                        stateF.text = "";
                        city.text = "";
                      });
                      Navigator.pop(context); // Close BottomSheet
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

//show state
  void _showStates(BuildContext context, List<StateData> states) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)?.selectState ?? 'Choose State',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                for (var stat in states)
                  RadioListTile<String>(
                    title: Text(stat.name ?? ''),
                    value: stat.name ?? '',
                    groupValue: selectedState,
                    onChanged: (value) {
                      setState(() {
                        selectedState = value!;
                        stateF.text = selectedState;
                        city.text = "";
                      });
                      Navigator.pop(context); // Close BottomSheet
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  //show city
  void _showCity(BuildContext context, List<CityData> cities) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)?.selectCity ?? 'Choose City',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                for (var cty in cities)
                  RadioListTile<String>(
                    title: Text(cty.name ?? ''),
                    value: cty.name ?? '',
                    groupValue: selectedCity,
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value!;
                        city.text = selectedCity;
                      });
                      Navigator.pop(context); // Close BottomSheet
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = BlocProvider.of<AddressCubit>(context);

    firstName.text = widget.addressData.firstName ?? '';
    lastName.text = widget.addressData.lastName ?? '';
    country.text = widget.addressData.country ?? '';
    stateF.text = widget.addressData.regionState ?? '';
    city.text = widget.addressData.city ?? '';
    zip.text = widget.addressData.zipCode ?? '';
    address.text = widget.addressData.address ?? '';
    email.text = widget.addressData.email ?? '';
    phone.text = widget.addressData.phoneNumber ?? '';
    _isSwitched = widget.addressData.isMainAddress ?? false;
     selectedCountry = country.text;
     selectedState = stateF.text;
     selectedCity = city.text;
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
            AppLocalizations.of(context)?.deliveryAddress ?? 'Delivery Address',
            style: FontStyles.getStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocConsumer<AddressCubit, AddressState>(builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            buildTextField(AppLocalizations.of(context)?.firstName ?? "First Name", firstName),
                            SizedBox(
                              height: 20,
                            ),
                            buildTextField(AppLocalizations.of(context)?.lastName ?? "Last Name", lastName),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("tap country");
                                    _cubit.getCountries();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.42,
                                    child: buildTextField(AppLocalizations.of(context)?.country ?? "Country", country, enabled: false),
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if (country.text.isEmpty) {
                                      showToast(AppLocalizations.of(context)?.chooseCountryFirst ?? "choose country first");
                                    } else {
                                      _cubit.getStates(selectedCountry);
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.42,
                                    child: buildTextField(AppLocalizations.of(context)?.state ?? "State", stateF, enabled: false),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (stateF.text.isEmpty) {
                                      showToast(AppLocalizations.of(context)?.chooseStateFirst ?? "Choose State First");
                                    } else {
                                      _cubit.getCities(selectedState);
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.42,
                                    child: buildTextField(AppLocalizations.of(context)?.city ?? "City", city, enabled: false),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.42,
                                  child: buildTextField(AppLocalizations.of(context)?.zipCode ?? "Zip Code", zip),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            buildTextField(AppLocalizations.of(context)?.address ?? "Address", address),
                            SizedBox(
                              height: 20,
                            ),
                            buildTextField(AppLocalizations.of(context)?.email ?? "Email", email),
                            SizedBox(
                              height: 20,
                            ),
                            buildTextField(
                              AppLocalizations.of(context)?.phoneNumber ?? "Phone Number",
                              phone,
                              inputType: TextInputType.phone,
                              prefix: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20), border: Border.all(width: 1)),
                                child: Text(
                                  " +254 ",
                                  style: FontStyles.getStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)?.savePrimaryAddress ?? 'Save as primary address',
                                  style: FontStyles.getStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                Switch(
                                  value: _isSwitched,
                                  // Current state of the switch
                                  onChanged: (value) {
                                    setState(() {
                                      _isSwitched = value; // Update the state
                                    });
                                  },
                                  activeColor: Colors.green,
                                  // Color when the switch is ON
                                  inactiveThumbColor: Colors.grey,
                                  // Color of thumb when OFF
                                  inactiveTrackColor: Colors.black12, // Track color when OFF
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final param = {
                            "first_name": firstName.text,
                            "last_name": lastName.text,
                            "company_name": '',
                            "address": address.text,
                            "country": selectedCountry,
                            "region_state": selectedState,
                            "city": selectedCity,
                            "zip_code": zip.text,
                            "email": email.text,
                            "phone_number": phone.text,
                            "is_main_address": _isSwitched
                          };

                          _cubit.updateAddress(param: param, addressUid: widget.addressData.id,);
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
                             AppLocalizations.of(context)?.saveAddress ?? "Save Address",
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
                      )
                    ],
                  ),
                  if (_showLoader)
                    Center(
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
            ),
          );
        }, listener: (context, state) {
          _showLoader = false;
          if (state is AddressLoading) {
            _showLoader = true;
          } else if (state is ACountryLoadedSuccess) {
            _showCountries(context, state.countries);
          } else if (state is StateLoadedSuccess) {
            if (state.states.isEmpty) {
              showToast(AppLocalizations.of(context)?.statesNotFound ?? "States not found.");
            } else {
              _showStates(context, state.states);
            }
          } else if (state is CityLoadedSuccess) {
            if (state.cities.isEmpty) {
              showToast(AppLocalizations.of(context)?.cityNotFound ?? "City not found.");
            } else {
              _showCity(context, state.cities);
            }
          } else if (state is AddAddressSuccess) {
            NavigationService.goBack();
          } else if (state is AddressFailure) {
            showToast(state.error);
          }
        }));
  }
}
