import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../CommonFiles/text_style.dart';

class SortBottomSheet extends StatefulWidget {
  final Function(int) onOptionSelected; // Callback to handle selection
  final Function(String)selectedValue;
  int? selectedOption; // Currently selected option index

  SortBottomSheet({required this.onOptionSelected, required this.selectedOption, required this.selectedValue});

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {

  //price_low_to_high
  //price_high_to_low

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Reset
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.sortBy ?? 'Sort By',
                style: FontStyles.getStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onOptionSelected(0); // Reset to the first option
                },
                child: Text(
                  AppLocalizations.of(context)?.reset ?? 'Reset',
                  style: FontStyles.getStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.red),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          // Options List
          ..._buildOptions(context),
          SizedBox(height: 16.0),
          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)?.close ?? 'Close',
                    style: FontStyles.getStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff5A5A5A),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    widget.selectedValue(((widget.selectedOption ?? 0) == 0) ? 'price_low_to_high' : 'price_high_to_low');
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)?.apply ?? 'Apply',style: FontStyles.getStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOptions(BuildContext context) {
    final List<String> _options = [
      AppLocalizations.of(context)?.priceLowToHigh ?? 'Price: low to high',
    AppLocalizations.of(context)?.priceHighToLow ?? 'Price: high to low',
    ];

    return List<Widget>.generate(
      _options.length,
      (index) {
        return RadioListTile<int>(
          value: index,
          groupValue: widget.selectedOption,
          activeColor: Colors.green,
          onChanged: (value) {
            widget.onOptionSelected(value!);
            setState(() {
              widget.selectedOption = value;
            });
          },
          title: Text(_options[index]),
        );
      },
    );
  }
}
