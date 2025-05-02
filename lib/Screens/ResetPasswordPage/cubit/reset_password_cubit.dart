import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/ResetPasswordPage/cubit/reset_password_state.dart';
import '../../../CommonFiles/common_variables.dart';


class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  final endPoint = 'auth/forgot-password/reset';

  // ResetPassword
  Future<void> resetPassword({required Map<String,dynamic> param}) async {
    emit(ResetPasswordLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: endPoint, method: 'post',body: param, fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      emit(ResetPasswordSuccess());

    } catch (e) {
      emit(ResetPasswordFailure('$e'));
    }
  }

}