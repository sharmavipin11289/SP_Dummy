import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import '../../../CommonFiles/common_variables.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  final endPoint = 'auth/forgot-password/request';

  // forgotPassword
  Future<void> forgotPassword({required Map<String,dynamic> param}) async {
    emit(ForgotPasswordLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: endPoint, method: 'post',body: param, fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordFailure('$e'));
    }
  }
}