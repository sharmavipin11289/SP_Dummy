import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/SharedPrefrence/shared_prefrence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({super.key});

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForAutoLogin();
    });
  }

  _checkForAutoLogin() async {
    if(isUserLoggedIn()) {
      NavigationService.navigateAndClearStack('/mainPage');
    }else{
      await clearAppCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Image.asset(
                      logo,
                      width: 213,
                      height: 45,
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      onboard,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: AutoSizeText(
                        AppLocalizations.of(context)?.exploreKenyanCulture ?? 'Explore Kenyan Culture:',
                        style: FontStyles.getStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF318531),
                        ),
                        maxLines: 1,
                        minFontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: AutoSizeText(
                        AppLocalizations.of(context)?.shopAuthentic ?? 'Shop Authentic Treasures with Purpose',
                        textAlign: TextAlign.center,
                        style: FontStyles.getStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        minFontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () async {
                        await SharedPreferencesHelper.saveString('token', '');
                        await SharedPreferencesHelper.remove('user_detail');
                        print("Create account tapped");
                        NavigationService.navigateTo('/signUp', arguments: true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            color: Colors.black,
                            height: 50,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)?.createAccount ?? 'Create Account',
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
                      onTap: () async {
                        await SharedPreferencesHelper.saveString('token', '');
                        await SharedPreferencesHelper.remove('user_detail');
                        NavigationService.navigateTo('/loginPage', arguments: true);
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
                    const SizedBox(height: 2),
                    TextButton(
                      onPressed: () {
                        NavigationService.navigateTo('/mainPage');
                      },
                      child: Text(
                        AppLocalizations.of(context)?.skip ?? "Skip",
                        style: FontStyles.getStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF006600),
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
      ),
    );
  }
}
