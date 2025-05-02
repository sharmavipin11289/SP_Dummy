/*
import 'package:flutter/material.dart';

class SortBottomSheet extends StatefulWidget {
  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  int selectedIndex = 0;

  final List<String> sortOptions = [
    "Popular",
    "Newest",
    "Customer Review",
    "Price: lowest to high",
    "Price: highest to low",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header with "Sort By" & "Reset"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sort By",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
                child: Text(
                  "Reset",
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// Sort Options List
          ...List.generate(sortOptions.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                margin: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: selectedIndex == index ? Color(0xFFF5F5F5) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedIndex == index
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selectedIndex == index ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      sortOptions[index],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          /// Buttons: Close & Apply
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Close", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, sortOptions[selectedIndex]);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Apply", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/
