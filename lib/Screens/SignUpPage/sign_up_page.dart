import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/SignUpPage/Model/country_model.dart';
import '../../CommonFiles/common_function.dart';
import '../../CommonFiles/common_variables.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';
import '../LoginPage/auth_service.dart';
import 'cubit/signup_cubit.dart';
import 'cubit/signup_state.dart';

class SignUpPage extends StatefulWidget {
  bool isFromOnBoard;

  SignUpPage({required this.isFromOnBoard});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var selectedCountry = '';
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController countryTextController = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  bool _shouldShowCountryLoader = false;
  bool _getCountryCalled = false;
  bool _isSecure = true;
  User? _user;

  void _socialGoogleLogin() async {
    final authService = AuthService();
    User? user = await authService.signInWithGoogle();
    setState(() => _user = user);
    final idToken = await user?.getIdToken();
    final param = {
      "token": idToken,
    };
    context.read<SignupCubit>().googleSignIn(param: param);
  }

  void _logout() async {
    await AuthService().signOut();
    setState(() => _user = null);
  }

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
                for (var country in countries)
                  RadioListTile<String>(
                    title: Text(country.name ?? ''),
                    value: country.name ?? '',
                    groupValue: selectedCountry,
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value!;
                        countryTextController.text = selectedCountry;
                      });
                      _getCountryCalled = false;
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
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
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
                                        child: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)?.createAnAccount ?? "Create an account",
                                    style: FontStyles.getStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: buildTextField(AppLocalizations.of(context)?.firstName ?? "First Name", firstName),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: buildTextField(AppLocalizations.of(context)?.lastName ?? "Last Name", lastName),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: buildTextField(
                                AppLocalizations.of(context)?.email ?? "Email",
                                email,
                                inputType: TextInputType.emailAddress,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: InkWell(
                                onTap: () {
                                  context.read<SignupCubit>().getCountries();
                                },
                                child: buildTextField(
                                  AppLocalizations.of(context)?.selectCountry ?? 'Select Country',
                                  countryTextController,
                                  enabled: false,
                                  suffixIcon: (_shouldShowCountryLoader)
                                      ? const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                    ),
                                  )
                                      : const Icon(Icons.arrow_drop_down_sharp),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: buildTextField(
                                AppLocalizations.of(context)?.phoneNumber ?? "Phone Number",
                                phone,
                                inputType: TextInputType.phone,
                                prefix: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(width: 1),
                                  ),
                                  child: Text(
                                    " +254 ",
                                    style: FontStyles.getStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: buildTextField(
                                AppLocalizations.of(context)?.password ?? "Password",
                                password,
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
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: const Color(0xFF318531),
                                    value: true,
                                    onChanged: (value) {
                                      // Handle checkbox logic
                                    },
                                  ),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: AppLocalizations.of(context)?.yesIUnderStandAndAgreeTo ?? "Yes, I understand and agree to ",
                                        style: FontStyles.getStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: AppLocalizations.of(context)?.sanaaTerm ?? "Sanaa's Terms",
                                            style: FontStyles.getStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF318531),
                                            ),
                                          ),
                                          TextSpan(
                                            text: AppLocalizations.of(context)?.and ?? " and ",
                                            style: FontStyles.getStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: AppLocalizations.of(context)?.privacyPolicy ?? "Privacy Policy.",
                                            style: FontStyles.getStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF318531),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            InkWell(
                              onTap: () {
                                _socialGoogleLogin();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(21),
                                    border: Border.all(width: 1),
                                  ),
                                  height: 42,
                                  width: 225,
                                  padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 9),
                                  child: Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)?.loginWithGoogle ?? 'Login with Google',
                                        style: FontStyles.getStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                      const Icon(Icons.g_mobiledata),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final param = {
                                    "fname": firstName.text,
                                    "lname": lastName.text,
                                    "name": (firstName.text.isEmpty) ? lastName.text : (firstName.text + ' ' + lastName.text),
                                    "email": email.text,
                                    "password": password.text,
                                    "password_confirmation": password.text,
                                    "contact_number": '${phonePrefix}${phone.text}',
                                    "country": selectedCountry,
                                  };
                                  context.read<SignupCubit>().signupUser(param: param);
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  backgroundColor: Colors.black,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)?.continuee ?? "Continue",
                                  style: FontStyles.getStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.isFromOnBoard) {
                                    NavigationService.navigateTo('/loginPage', arguments: false);
                                  } else {
                                    NavigationService.goBack();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)?.alreadyHaveAnAccount ?? 'Already have an account? ',
                                      style: FontStyles.getStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)?.login ?? 'Login',
                                      style: FontStyles.getStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF006600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    // Bottom image fixed at the bottom
                    Image.asset(bottombar),
                  ],
                ),
                // Show the loader if the state is loading
                if (state is SignupLoading || state is GoogleLoginLoading) loaderWidget(),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is SignupSuccess) {
          NavigationService.navigateTo(
            '/otpPage',
            arguments: {'email': email.text, 'otpType': OtpType.signup, 'otpFor': 'email', 'phone': phone.text},
          );
        } else if (state is SignupFailure) {
          if (state.error.contains('409')) {
            NavigationService.navigateTo(
              '/otpPage',
              arguments: {'email': email.text, 'otpType': OtpType.signup, 'otpFor': 'email', 'phone': phone.text},
            );
          } else {
            showToast(state.error);
          }
        } else if (state is CountryLoading) {
          _getCountryCalled = false;
          _shouldShowCountryLoader = true;
        } else if (state is CountryLoadedSuccess) {
          _shouldShowCountryLoader = false;
          if (_getCountryCalled == false) {
            _getCountryCalled = true;
            _showCountries(context, state.countries);
          }
        } else if (state is CountryLoadedFailed) {
          _getCountryCalled = false;
          _shouldShowCountryLoader = false;
          showToast(state.error);
        } else if (state is GoogleLoginLoading) {
        } else if (state is GoogleLoginSuccess) {
        } else if (state is GoogleLoginFailed) {
          showToast(state.error);
        }
      },
    );
  }
}
