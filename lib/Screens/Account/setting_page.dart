import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:sanaa/Provider/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/Account/Model/currency_model.dart';
import 'package:sanaa/Screens/Account/Model/language_model.dart';
import 'package:sanaa/Screens/Account/cubit/account_cubit.dart';
import 'package:sanaa/Screens/Account/cubit/account_state.dart';
import 'package:sanaa/SharedPrefrence/shared_prefrence.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingPage extends StatefulWidget {
  SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  LanguageData? selectedLanguage;
  String selectedCurrency = SharedPreferencesHelper.getString('savedCurrency') ?? '';
  bool _showCurrencyLoader = false;
  bool _showLanguageLoader = false;
  late AccountCubit _cubit;
  List<LanguageData> _languages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLanguage();
    _cubit = BlocProvider.of<AccountCubit>(context);
  }

  _setLanguage() {
    final savedLanguage = SharedPreferencesHelper.getCustomObject<LanguageData>(
      'language',
      (json) => LanguageData.fromJson(json),
    );
    setState(() {
      selectedLanguage = savedLanguage ?? LanguageData(name: 'English', locale: 'en');
    });
  }

  // Default selected language
  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        final provider = Provider.of<LocalProvider>(context, listen: false);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)?.chooseLanguage ?? 'Choose Language',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              for (var language in _languages)
                RadioListTile<LanguageData>(
                  title: Text(language.name ?? ''),
                  value: language,
                  groupValue: _languages.firstWhere(
                    (lang) => lang.locale == selectedLanguage?.locale,
                    orElse: () => selectedLanguage ?? LanguageData(name: 'English', locale: 'en'),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value!;
                      print("Selected::::::::::: ${selectedLanguage?.name} ${selectedLanguage?.locale}");
                      provider.setLocale(Locale(selectedLanguage?.locale ?? 'en'));
                      SharedPreferencesHelper.saveCustomObject('language', language);
                    });

                    Navigator.pop(context); // Close BottomSheet
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencyBottomSheet(BuildContext context, List<CurrencyData> currencies) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)?.selectCurrency ?? 'Choose Currency',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              for (var currency in currencies)
                RadioListTile<String>(
                  title: Text(currency.name ?? 'KEN'),
                  value: currency.code ?? 'KEN',
                  groupValue: selectedCurrency,
                  onChanged: (value) {
                    setState(() {
                      selectedCurrency = value!;
                      SharedPreferencesHelper.saveString('savedCurrency', selectedCurrency);
                    });
                    Navigator.pop(context); // Close BottomSheet
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () {
                print("back>>>");
                NavigationService.goBack();
              },
              child: Image.asset(back)),
        ),
        title: Text(
          AppLocalizations.of(context)?.settings ?? 'Settings',
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<AccountCubit, AccountState>(builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    if (_languages.isEmpty) {
                      _cubit.getLanguage();
                    } else {
                      _showLanguageBottomSheet(context);
                    }
                  },
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)?.language ?? '',
                          style: FontStyles.getStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        if (_showLanguageLoader)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                            ),
                          ),
                        if (!_showLanguageLoader)
                          Text(
                            selectedLanguage?.name ?? 'English',
                            style: FontStyles.getStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                          ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 24,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () async {
                    await context.read<AccountCubit>().getCurrencies();
                  },
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)?.currency ?? 'Currency',
                          style: FontStyles.getStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        if (_showCurrencyLoader)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                            ),
                          ),
                        if (!_showCurrencyLoader)
                          Text(
                            selectedCurrency,
                            style: FontStyles.getStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                          ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 24,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    NavigationService.navigateTo('/forgotPage');
                  },
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)?.changePassword ?? 'Change Password',
                          style: FontStyles.getStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 24,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    NavigationService.navigateTo('/webViewScreen', arguments: 'https://website-sanaa.arshantanu.in/privacy-policy');
                  },
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)?.privacyPolicy ?? 'Privacy Policy',
                          style: FontStyles.getStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 24,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        );
      }, listener: (context, state) {
        if (state is CurrencyGetSuccess) {
          _showCurrencyLoader = false;
          _showCurrencyBottomSheet(context, state.currencies);
        } else if (state is CurrencyGetFailed) {
          _showCurrencyLoader = false;
        } else if (state is CurrencyLoading) {
          _showCurrencyLoader = true;
        } else if (state is LanguageGetSuccess) {
          _showLanguageLoader = false;
          _languages = state.languages;
          _showLanguageBottomSheet(context);
        } else if (state is LanguageGetFailed) {
          _showLanguageLoader = false;
        } else if (state is LanguageLoading) {
          _showLanguageLoader = true;
        }
      }),
    );
  }
}
