import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/SignUpPage/Model/country_model.dart';
import 'package:sanaa/Screens/SignUpPage/cubit/signup_state.dart';

import '../../../CommonFiles/common_variables.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  final endPoint = 'auth/signup/request';
  final countriesEndpoint = 'locations/countries';
  final _googleLogin = "auth/google/signin";

  // Method to handle user signup
  Future<void> signupUser({required Map<String,dynamic> param}) async {
    emit(SignupLoading()); // Emit loading state
    final error = validateSignupFields(param);

    if( error != null) {
      emit(SignupFailure(error));
    }
    else{
      try {
        final response = await ApiService().request(endpoint: endPoint, method: 'post',body: param, fromJson: (json) => CommonResponse.fromJson(json));
        print(response.message);
        if(response.data == null) {
          emit(SignupFailure(response.message ?? somethingWentWrong));  
        }
        else{
          emit(SignupSuccess());
        }
      } catch (e) {
        emit(SignupFailure(e.toString()));
      }
    }
  }

  Future<void> getCountries() async {
    emit(CountryLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: countriesEndpoint, method: 'get', fromJson: (json) => CountryModel.fromJson(json));
      print('data inside>>>>>>>>>>>>>>>> ');
      emit(CountryLoadedSuccess(response.data ?? []));

    } catch (e) {
      emit(CountryLoadedFailed('$e'));
    }
  }

  String? validateSignupFields(Map<String, dynamic> params) {
    // Validate name
    if (params['fname'] == null || params['fname'].toString().trim().isEmpty) {
      return 'First Name is required.';
    }

    if (params['lname'] == null || params['lname'].toString().trim().isEmpty) {
      return 'Last Name is required.';
    }

    // Validate email
    if (params['email'] == null || params['email'].toString().trim().isEmpty) {
      return 'Email is required.';
    } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(params['email'])) {
      return 'Invalid email format.';
    }

    // Validate password
    if (params['password'] == null || params['password'].toString().trim().isEmpty) {
      return 'Password is required.';
    } /*else if (params['password'].toString().length < 6) {
      return 'Password must be at least 6 characters.';
    }*/

    // Validate password confirmation
    if (params['password_confirmation'] == null || params['password_confirmation'].toString().trim().isEmpty) {
      return 'Password confirmation is required.';
    } else if (params['password'] != params['password_confirmation']) {
      return 'Passwords do not match.';
    }

    // Validate contact number
    if (params['contact_number'] == null || params['contact_number'].toString().trim().isEmpty) {
      return 'Phone no. required';
    } else if (!RegExp(r"^\+?[0-9]{8,15}$").hasMatch(params['contact_number'])) {
      return 'Invalid contact number.';
    }

    // Validate country
    if (params['country'] == null || params['country'].toString().trim().isEmpty) {
      return 'Country is required.';
    }

    // Return null if no errors
    return null;
  }

  Future<void> googleSignIn({required Map<String,dynamic> param}) async {
    print(param);
    emit(GoogleLoginLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _googleLogin, method: 'post',body: param, fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      emit(GoogleLoginSuccess(response: response));
    } catch (e) {
      emit(GoogleLoginFailed('$e'));
    }
  }
}