import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/ResetPasswordPage/cubit/reset_password_cubit.dart';
import 'package:sanaa/Screens/ResetPasswordPage/cubit/reset_password_state.dart';
import '../../CommonFiles/common_function.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../SharedPrefrence/shared_prefrence.dart';

class ResetPasswordPage extends StatefulWidget {
  Map<String, dynamic> args;

  ResetPasswordPage(this.args, {super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _password = TextEditingController();
  TextEditingController _cnfrmPassword = TextEditingController();
  String resetToken = '';
  String email = '';
  bool _showLoader = false;
  bool _isSecure = true;
  bool _isSecureCnfrm = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resetToken = widget.args['token'] as String;
    email = widget.args['email'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state)  async {
        if (state is ResetPasswordFailure) {
          showToast(state.error);
          _showLoader = false;
        } else if (state is ResetPasswordLoading) {
          _showLoader = true;
        } else if (state is ResetPasswordSuccess) {
          await SharedPreferencesHelper.remove('token');
          await SharedPreferencesHelper.remove('user_detail');
          NavigationService.navigateAndClearStack('/loginPage',arguments: false);
        }
      },
      builder: (context, state) {
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
                                AppLocalizations.of(context)?.resetPassword ?? "Reset Password",
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
                            AppLocalizations.of(context)?.pleaseEnterAndConfirmNewPassword ?? 'Please enter and confirm your new password. Minimum of 8 characters.',
                            style: FontStyles.getStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 20),
                          buildTextField(
                            AppLocalizations.of(context)?.newPassword ?? 'New Password',
                            _password,
                            isPassword: _isSecure,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isSecure = !_isSecure;
                                });
                              },
                              icon: Icon((_isSecure) ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          SizedBox(height: 20),
                          buildTextField(
                            AppLocalizations.of(context)?.confirmPassword ?? 'Confirm Password',
                            _cnfrmPassword,
                            isPassword: _isSecureCnfrm,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isSecureCnfrm = !_isSecureCnfrm;
                                });
                              },
                              icon: Icon((_isSecureCnfrm) ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        //NavigationService.navigateAndClearStack('/loginPage');
                        if (_password.text.isEmpty) {
                          showToast(AppLocalizations.of(context)?.passwordShouldNotBeEmpty ?? "Password should not be empty");
                        } else if (_cnfrmPassword.text.isEmpty) {
                          showToast(AppLocalizations.of(context)?.confirmPasswordShouldNotBeEmpty ?? "Confirm Password should not be empty");
                        } else if (_password.text != _cnfrmPassword.text) {
                          showToast(AppLocalizations.of(context)?.passwordAndConfirmPasswordShouldBeTheSame ?? "Password and Confirm Password should be the same");
                        } else {
                          final param = {"email_or_phone_number": email, "password": _password.text, "token": resetToken};
                          context.read<ResetPasswordCubit>().resetPassword(param: param);
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
                                AppLocalizations.of(context)?.confirm ?? 'Confirm',
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
                      height: 40,
                    ),
                    Image.asset(bottombar),
                  ],
                ),
                if (_showLoader)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
