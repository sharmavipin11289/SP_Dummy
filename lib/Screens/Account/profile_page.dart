import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/Screens/Account/Model/user_detail_model.dart';
import 'package:sanaa/Screens/Account/cubit/account_cubit.dart';
import '../../CommonFiles/common_function.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';
import 'cubit/account_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AccountCubit _cubit;
  UserDetail? userDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = BlocProvider.of<AccountCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getProfileData();
    });
  }

  _getProfileData() async {
    final detail = await _cubit.getSavedUserDetail();
    print(detail);
    if (detail == null) {
      await _cubit.getUserDetails();
    } else {
      setState(() {
        userDetail = detail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              NavigationService.goBack();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(back),
            ),
          ),
          title: Text(
            AppLocalizations.of(context)?.profile ?? 'Profile',
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
                  Row(
                    children: [
                      SizedBox(
                        width: 66,
                        height: 66,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(33),
                          child: Image.network(
                            userDetail?.profilePictureUrl ?? dummyImageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Text(
                          userDetail?.name ?? '',
                          style: FontStyles.getStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      NavigationService.navigateTo('/profileDetail');
                    },
                    child: Container(
                      height: 40,
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)?.personalInfo ?? 'Personal Information',
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
                  GestureDetector(
                    onTap: () {
                      NavigationService.navigateTo('/deliveryAddress');
                    },
                    child: Container(
                      height: 40,
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)?.deliveryAddress ?? 'Delivery Address',
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
                  GestureDetector(
                    onTap: () {
                      NavigationService.navigateTo('/orderList',arguments: false);
                    },
                    child: Container(
                      height: 40,
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)?.orders ?? 'Orders',
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
        }, listener: (context, state) async {
          if (state is ProfileSuccess) {
            if (state.userDetail != null) {
              await _cubit.saveUserDetail(state.userDetail!);
              userDetail = state.userDetail;
            }
          } else if (state is ProfileFailed) {
            showToast(state.error);
          }
        }));
  }
}
