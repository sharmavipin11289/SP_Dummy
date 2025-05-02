import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class DropDownContainer extends StatefulWidget {
  String option;
  Color backgroundColor;
  Color borderColor;
  DropDownContainer({required this.option, this.backgroundColor =  Colors.white, this.borderColor = Colors.black});

  @override
  State<DropDownContainer> createState() => _DropDownContainerState();
}

class _DropDownContainerState extends State<DropDownContainer> {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: widget.borderColor, width: 1.0),
        borderRadius: BorderRadius.circular(22.0),
        color: widget.backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.option,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(width: 8.0), // Spacing between text and icon
          Icon(
            Icons.arrow_drop_down,
            size: 24.0,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
