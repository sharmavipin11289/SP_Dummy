import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/LoginPage/cubit/login_cubit.dart';
import 'package:sanaa/Screens/LoginPage/cubit/login_state.dart';
import '../../CommonFiles/common_function.dart';
import '../../CommonFiles/common_variables.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';

class LoginPage extends StatefulWidget {
  bool isFromOnBoard;

  LoginPage({super.key, required this.isFromOnBoard});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _showLoader = false;
  bool _isSecure = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<LoginCubit, LoginState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false, // Prevent resizing when keyboard appears
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                  ),
                                  child: Container(
                                    height: (360 * 239) / size.width,
                                    width: size.width,
                                    child: Image.asset(
                                      demo1,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (widget.isFromOnBoard)
                                  GestureDetector(
                                    onTap: () {
                                      NavigationService.goBack();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Container(
                                          color: Colors.black,
                                          width: 36,
                                          height: 36,
                                          child: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                            size: 19,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 30),
                                  Text(
                                    AppLocalizations.of(context)?.welcomeToSanaa ?? 'Welcome to Sanaa',
                                    style: FontStyles.getStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    AppLocalizations.of(context)?.exploreKenyan ??
                                        'Explore Kenyan Culture:\nShop Authentic Treasures with Purpose',
                                    textAlign: TextAlign.center,
                                    style: FontStyles.getStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  buildTextField(
                                    AppLocalizations.of(context)?.emailPhoneNumber ?? "Email / Phone Number",
                                    _email,
                                    inputType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 20),
                                  buildTextField(
                                    AppLocalizations.of(context)?.password ?? "Password",
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
                                  const SizedBox(height: 15),
                                  GestureDetector(
                                    onTap: () {
                                      NavigationService.navigateTo('/forgotPage');
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)?.forgotPassword ?? 'Forgot Password?',
                                      style: FontStyles.getStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  GestureDetector(
                                    onTap: () {
                                      final param = {"email_or_phone_number": _email.text, "password": _password.text};
                                      context.read<LoginCubit>().loginUser(param: param);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Container(
                                          color: Colors.black,
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)?.login ?? 'Login',
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
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      //if (widget.isFromOnBoard) {
                                        NavigationService.navigateTo('/signUp', arguments: false);
                                      /*} else {
                                        NavigationService.goBack();
                                      }*/
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)?.dontHaveAccont ?? 'Don\'t have an account yet? ',
                                          style: FontStyles.getStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)?.signUp ?? 'Sign up',
                                          style: FontStyles.getStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF006600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Add padding to ensure content is not obscured by keyboard
                                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Footer image fixed at the bottom
                    Image.asset(bottombar),
                  ],
                ),
                // Loader
                if (_showLoader)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        _showLoader = false;
        if (state is LoginSuccess) {
          print('Success:::::::::');
          NavigationService.navigateTo(
            '/otpPage',
            arguments: {
              'email': _email.text,
              'otpType': OtpType.login,
            },
          );
        } else if (state is LoginFailure) {
          print('errr:::::::');
          print(state.error);
          if (state.error.contains('409')) {
            NavigationService.navigateTo(
              '/otpPage',
              arguments: {'email': state.extra?[0] ?? '', 'otpType': OtpType.signup, 'otpFor': 'email', 'phone': state.extra?[1] ?? ''},
            );
          } else {
            showToast(state.error);
          }
        } else if (state is LoginLoading) {
          _showLoader = true;
        }
      },
    );
  }
}