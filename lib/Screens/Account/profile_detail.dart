import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/Screens/Account/Model/user_detail_model.dart';
import 'package:sanaa/Screens/Account/cubit/account_cubit.dart';
import 'package:sanaa/Screens/Account/cubit/account_state.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  bool _showLoader = false;
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

  _getProfileData() async{
    final detail = await _cubit.getSavedUserDetail();
    print(detail);
    if (detail == null) {
      _cubit.getUserDetails();
    }else{
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
          onTap: (){
            NavigationService.goBack();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(back),
          ),
        ),

        title: Text(
          AppLocalizations.of(context)?.profileDetail ?? 'Profile Detail ',
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body:  BlocConsumer<AccountCubit,AccountState> (builder: (context,state) {
        return  SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [

                    Container(

                      child: Column(
                        children: [
                          SizedBox(
                            width: 90,
                            height: 90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image.network(
                                userDetail?.profilePictureUrl ?? dummyImageUrl,

                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            userDetail?.name ?? '',
                            style: FontStyles.getStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.fullName ?? 'Full Name',
                            style: FontStyles.getStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 16,),
                          Row(children: [
                            Icon(Icons.person,),
                            SizedBox(width: 18,),
                            Expanded(
                              child: Text(
                                userDetail?.name ?? '',
                                style: FontStyles.getStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),],),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.emailAddress ?? 'Email Address',
                            style: FontStyles.getStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 16,),
                          Row(children: [
                            Icon(Icons.email_outlined,),
                            SizedBox(width: 18,),
                            Expanded(
                              child: Text(
                                userDetail?.email ?? '',
                                style: FontStyles.getStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),],),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 22,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.phoneNumber ?? 'Phone Number',
                            style: FontStyles.getStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 16,),
                          Row(children: [
                            Icon(Icons.phone_outlined,),
                            SizedBox(width: 18,),
                            Text(
                              userDetail?.contactNumber ?? '',
                              style: FontStyles.getStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),],),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if(_showLoader)
                Center(child: CircularProgressIndicator(),),
            ],
          ),
        );
      }, listener: (context,state) async {
        _showLoader = false;
        if(state is ProfileSuccess) {
          if(state.userDetail != null) {
            await _cubit.saveUserDetail(state.userDetail!);
            userDetail = state.userDetail;
          }
        }else if(state is ProfileFailed) {
          showToast(state.error);
        }else if (state is ProfileLoading) {
          _showLoader = true;
        }
      })
    );
  }
}
