import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/OTPScreen/cubit/otp_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../CommonFiles/common_function.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../SharedPrefrence/shared_prefrence.dart';
import 'cubit/otp_state.dart';

class OtpPage extends StatefulWidget {
  Map<String, dynamic> args;

  OtpPage(this.args, {super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final defaultPinTheme = PinTheme(
    width: 70,
    height: 70,
    margin: EdgeInsets.symmetric(horizontal: 8),
    textStyle: FontStyles.getStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
    decoration: BoxDecoration(
      border: Border.all(color: Color(0xFFBBBBBB)),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  String email = '';
  String phone = '';
  OtpType otpType = OtpType.signup;
  String otpFor = 'email';
  bool _showLoader = false;
  String _emailOTP = '';
  String _phoneOTP = '';
  TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = widget.args['email'] as String;
    otpType = widget.args['otpType'] as OtpType;
    if (otpType == OtpType.signup) {
      otpFor = widget.args['otpFor'] as String;
      phone = widget.args['phone'] as String;
    }
    print("Email: $email");
    print("OTP Type: $otpType");
    print("OTPFor: $otpFor");
    print("Phone: $phone");


    if (otpType == OtpType.unAuthorizedLogin) {
      BlocProvider.of<OTPCubit>(context).resendOTP(param: {'email': email});
    } else if (otpType == OtpType.unAuthorizedSignup) {
      BlocProvider.of<OTPCubit>(context).resendOTP(param: {'email': email});
      BlocProvider.of<OTPCubit>(context).resendOTP(param: {'phone_number': phone});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OTPCubit, OTPState>(
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
                                  if (otpFor.toLowerCase() == 'email') {
                                    NavigationService.goBack();
                                  } else {
                                    setState(() {
                                      otpFor = 'email';
                                    });
                                  }
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
                          AutoSizeText(
                            (AppLocalizations.of(context)?.enterVerificationCode ?? "Enter Verification Code"),
                            textAlign: TextAlign.left,
                            style: FontStyles.getStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            minFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 15),
                          Text(
                            '${AppLocalizations.of(context)?.theOneTimePasswordWasSentTo ?? 'The one-time password was sent to'} ${(otpFor.toLowerCase() == 'email') ? email : phone}',
                            style: FontStyles.getStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Pinput(
                              controller: _otpController,
                              defaultPinTheme: defaultPinTheme,
                              length: 4, // Specify the length of the PIN
                              onCompleted: (pin) => print('Entered PIN: $pin'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (otpType == OtpType.signup) {
                          if (otpFor.toLowerCase() == 'email') {
                            _emailOTP = _otpController.text;
                            setState(() {
                              _otpController.text = "";
                              otpFor = 'phone';
                            });
                          } else {
                            _phoneOTP = _otpController.text;
                            final param = {"email": email, "phone_number": '+254$phone', "email_otp": _emailOTP, "phone_otp": _phoneOTP};
                            context.read<OTPCubit>().validateOTP(param: param);
                          }
                        } else if (otpType == OtpType.login) {
                          final param = {
                            "email_or_phone_number": email,
                            "otp": _otpController.text,
                          };
                          context.read<OTPCubit>().validateLoginOTP(param: param);
                        } else if (otpType == OtpType.forgotPassword) {
                          final param = {
                            "email_or_phone_number": email,
                            "otp":  _otpController.text,
                          };
                          print("Forgot call>>>>>>>>>>>>");
                          context.read<OTPCubit>().validateForgotPasswordOTP(param: param);
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
                                AppLocalizations.of(context)?.verifyContinue ?? 'Verify & Continue',
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
                if (_showLoader) Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
      listener: (context, state) async {
        _showLoader = false;

        if (state is OTPSuccess) {
          NavigationService.navigateAndClearStack('/loginPage',arguments: true);
        } else if (state is LoginOTPSuccess) {
          print("Login OTP success >>>>>>>>>>>> TOKEN:: ${state.response.token}");
          await SharedPreferencesHelper.saveString('token', state.response.token ?? '');
          NavigationService.navigateAndClearStack('/mainPage');
        } else if (state is OTPToForgotPswdSuccess) {
          NavigationService.navigateTo(
            '/resetPassword',
            arguments: {'token': state.resetToken, 'email': email},
          );
        } else if (state is OTPFailure) {
          showToast(state.error);
        } else if (state is OTPLoading) {
          _showLoader = true;
        }
      },
    );
  }
}
