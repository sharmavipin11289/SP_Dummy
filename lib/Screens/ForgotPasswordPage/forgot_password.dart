import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/ForgotPasswordPage/cubit/forgot_password_cubit.dart';
import 'package:sanaa/Screens/ForgotPasswordPage/cubit/forgot_password_state.dart';
import '../../CommonFiles/common_variables.dart';
import '../../CommonFiles/text_style.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _email = TextEditingController();
  bool _showLoader = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit,ForgotPasswordState> (listener: (context, state) {
      _showLoader = false;
      if (state is ForgotPasswordLoading) {
        _showLoader = true;
      } else if (state is ForgotPasswordFailure) {
        showToast(state.error);
      } else if (state is ForgotPasswordSuccess) {
        NavigationService.navigateTo(
          '/otpPage',
          arguments: {'email': _email.text, 'otpType': OtpType.forgotPassword},
        );
      }
    },builder: (context,state) {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                NavigationService.goBack();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                    color: Colors.black,
                                    width: 36,
                                    height: 36,
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 19,
                                    )),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 34),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)?.forgotPassword ?? "Forgot Password",
                              style: FontStyles.getStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          AppLocalizations.of(context)?.noWorries ?? 'No worries, we’ll send you reset instructions',
                          style: FontStyles.getStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 20),
                        buildTextField(AppLocalizations.of(context)?.email ?? 'Email', _email),
                      ],
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      //NavigationService.navigateTo('/resetPassword');
                      if (_email.text.isEmpty) {
                        showToast(AppLocalizations.of(context)?.emailShouldNotBeEmpty ?? "Email should not be empty");
                      } else {
                        final param = {"email_or_phone_number": _email.text};
                        context.read<ForgotPasswordCubit>().forgotPassword(param: param);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          color: Colors.black,
                          height: 50,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)?.resetPassword ?? 'Reset Password',
                              style: FontStyles.getStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      NavigationService.goBack();
                    },
                    child: Text(
                      AppLocalizations.of(context)?.backToLogin ?? 'Back To Login',
                      style: FontStyles.getStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0Xff318531), decoration: TextDecoration.underline),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(bottombar),
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
    },);

  }
}
