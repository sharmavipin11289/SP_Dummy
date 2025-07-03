import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Text(''),
        title: Text(
          AppLocalizations
              .of(context)
              ?.account ?? 'Account',
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Future.delayed(Duration(milliseconds: 200), () {
                    NavigationService.navigateTo('/profilePage');
                  });
                },
                child: Container(
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations
                            .of(context)
                            ?.profile ?? 'Profile',
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
                  Future.delayed(Duration(milliseconds: 200), () {
                    NavigationService.navigateTo('/settingPage');
                  });
                },
                child: Container(
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations
                            .of(context)
                            ?.settings ?? 'Settings',
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
                   NavigationService.navigateTo('/webViewScreen',arguments: 'https://website-sanaa.arshantanu.in/contact-us');
                },
                child: Container(
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations
                            .of(context)
                            ?.help ?? 'Help',
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
      ),
    );
  }
}
