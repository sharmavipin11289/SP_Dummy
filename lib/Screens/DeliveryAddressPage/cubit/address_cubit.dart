import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/Model/address_model.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/Model/state_model.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/cubit/address_state.dart';
import 'package:sanaa/Screens/OTPScreen/Model/forgot_otp_model.dart';
import 'package:sanaa/Screens/SignUpPage/cubit/signup_state.dart';

import '../../../CommonFiles/common_variables.dart';
import '../../SignUpPage/Model/country_model.dart';
import '../Model/city_model.dart';


class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial());

  final _endPoint = 'delivery-address';
  final _countriesEndpoint = 'locations/countries';
  final _stateEndpoint = 'locations/states?country=';
  final _cityEndpoint = 'locations/cities?state=';
  final _addAddressEndpoint = 'delivery-address';

  Future<void> getAddresses() async{
      emit(AddressLoading());
      try {
        final response = await ApiService().request(endpoint: _endPoint, method: 'get', fromJson: (json) => AddressModel.fromJson(json));
        print(response.message);
        emit(AddressSuccess(response.data ?? []));
      } catch (e) {
        emit(AddressFailure('$e'));
      }
  }

  Future<void> getCountries() async {
    emit(AddressLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _countriesEndpoint, method: 'get', fromJson: (json) => CountryModel.fromJson(json));
      print('data inside>>>>>>>>>>>>>>>> ');
      emit(ACountryLoadedSuccess(response.data ?? []));

    } catch (e) {
      emit(ACountryLoadedFailed('$e'));
    }
  }

  Future<void> getStates(String country) async {
    emit(AddressLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _stateEndpoint + country, method: 'get', fromJson: (json) => StateModel.fromJson(json));
      print('data inside>>>>>>>>>>>>>>>> ');
      emit(StateLoadedSuccess(response.data ?? []));

    } catch (e) {
      emit(StateLoadedFailed('$e'));
    }
  }

  Future<void> getCities(String state) async {
    emit(AddressLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _cityEndpoint + state, method: 'get', fromJson: (json) => CityModel.fromJson(json));
      print('data inside>>>>>>>>>>>>>>>> ');
      emit(CityLoadedSuccess(response.data ?? []));

    } catch (e) {
      emit(CityLoadedFailed('$e'));
    }
  }

  Future<void> saveAddress({required Map<String,dynamic> param}) async {
    emit(AddressLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _addAddressEndpoint, method: 'post',body: param, fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      emit(AddAddressSuccess());
    } catch (e) {
      emit(AddressFailure('$e'));
    }
  }

  Future<void> updateAddress({required Map<String,dynamic> param, required addressUid}) async {
    emit(AddressLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _addAddressEndpoint + '/$addressUid', method: 'post',body: param, fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      emit(AddAddressSuccess());
    } catch (e) {
      emit(AddressFailure('$e'));
    }
  }

}