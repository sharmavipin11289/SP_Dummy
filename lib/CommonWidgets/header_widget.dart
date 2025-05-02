import 'package:flutter/material.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:sanaa/Screens/Account/Model/user_detail_model.dart';
import '../CommonFiles/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeaderWidget extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  UserDetail? userDetail;

  HeaderWidget({super.key, required this.scaffoldKey, this.userDetail});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.welcomeBack ?? 'Welcome Back!',
                  style: FontStyles.getStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF5A5A5A),
                  ),
                ),
            
                Text(
                  widget.userDetail?.name ?? 'Guest',
                  style: FontStyles.getStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          GestureDetector(onTap: (){
            widget.scaffoldKey.currentState?.openEndDrawer();
          }, child: Image.asset(sideMenu))
        ],
      ),
    );
  }
}
