import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:sanaa/Provider/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/Account/Model/currency_model.dart';
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
  String selectedLanguage = 'English';
  String selectedCurrency = SharedPreferencesHelper.getString('savedCurrency') ?? '';
  bool _showCurrencyLoader = false;

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
                AppLocalizations
                    .of(context)
                    ?.chooseLanguage ?? 'Choose Language',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'English',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                  provider.setLocale(Locale('en'));
                  Navigator.pop(context); // Close BottomSheet
                },
              ),
              RadioListTile<String>(
                title: const Text('Swahili'),
                value: 'Swahili',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                  provider.setLocale(Locale('sw'));
                  Navigator.pop(context); // Close BottomSheet
                },
              ),
              RadioListTile<String>(
                title: const Text('Spanish'),
                value: 'Spanish',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                  provider.setLocale(Locale('es'));
                  Navigator.pop(context); // Close BottomSheet
                },
              ),
              RadioListTile<String>(
                title: const Text('French'),
                value: 'French',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                  provider.setLocale(Locale('fr'));
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
                AppLocalizations
                    .of(context)
                    ?.selectCurrency ?? 'Choose Currency',
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
          child: GestureDetector( onTap: () {
            print("back>>>");
            NavigationService.goBack();
          },child: Image.asset(back)),
        ),
        title: Text(
          AppLocalizations
              .of(context)
              ?.settings ?? 'Settings',
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
                    _showLanguageBottomSheet(context);
                  },
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations
                              .of(context)
                              ?.language ?? '',
                          style: FontStyles.getStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                          Text(
                            selectedLanguage,
                            style: FontStyles.getStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500
                            ),
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
                          AppLocalizations
                              .of(context)
                              ?.currency ?? 'Currency',
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
                        if(!_showCurrencyLoader)
                          Text(
                            selectedCurrency,
                            style: FontStyles.getStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500
                            ),
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
                Container(
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations
                            .of(context)
                            ?.changePassword ?? 'Change Password',
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
                Divider(),
                Container(
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations
                            .of(context)
                            ?.privacyPolicy ?? 'Privacy Policy',
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
                Divider(),
              ],
            ),
          ),
        );
      },
          listener: (context, state) {
            if (state is CurrencyGetSuccess) {
              _showCurrencyLoader = false;
              _showCurrencyBottomSheet(context, state.currencies);
            } else if (state is CurrencyGetFailed) {
              _showCurrencyLoader = false;
            } else if (state is CurrencyLoading) {
              _showCurrencyLoader = true;
            }
          }),
    );
  }
}

