import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/OTPScreen/Model/forgot_otp_model.dart';
import 'package:sanaa/Screens/SignUpPage/cubit/signup_state.dart';

import '../../../CommonFiles/common_variables.dart';
import 'otp_state.dart';

class OTPCubit extends Cubit<OTPState> {
  OTPCubit() : super(OTPInitial());

  final endPoint = 'auth/signup/verify-otp';
  final loginOtpVerification = 'auth/signin/verify-otp';
  final forgotOtpVerification = 'auth/forgot-password/verify-otp';
  final resendOtpEndPoint = 'auth/signup/resend-otp';

  // validate OTP
  Future<void> validateOTP({required Map<String,dynamic> param}) async {
    emit(OTPLoading()); // Emit loading state
      try {
        final response = await ApiService().request(endpoint: endPoint, method: 'post',body: param, fromJson: (json) => CommonResponse.fromJson(json));
        print(response.message);
        emit(OTPSuccess());
      } catch (e) {
        emit(OTPFailure('$e'));
      }
  }

  //forgotPassword otp validation
  Future<void> validateForgotPasswordOTP({required Map<String,dynamic> param}) async {
    emit(OTPLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: forgotOtpVerification, method: 'post',body: param, fromJson: (json) => ForgotOtpModel.fromJson(json));
      print(response.message);
      emit(OTPToForgotPswdSuccess(response.data?.resetToken ?? ''));
    } catch (e) {
      emit(OTPFailure('$e'));
    }
  }

  //login otp verification
  Future<void> validateLoginOTP({required Map<String,dynamic> param}) async {
    emit(OTPLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: loginOtpVerification, method: 'post',body: param, fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      emit(LoginOTPSuccess(response));
    } catch (e) {
      emit(OTPFailure('$e'));
    }
  }

  //ResendOTP
  Future<void> resendOTP({required Map<String,dynamic> param}) async {
    emit(OTPLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: resendOtpEndPoint, method: 'post',body: param, fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      if(response.data == null) {
        emit(OTPFailure(response.message ?? somethingWentWrong));
      }
      else{
        emit(OTPSendSuccess());
      }
    } catch (e) {
      emit(OTPFailure('$e'));
    }
  }

}