import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:sanaa/CommonFiles/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Navigation/navigation_service.dart';
import '../SharedPrefrence/shared_prefrence.dart';

//build text field
Widget buildTextField(String label, TextEditingController controller,
    {bool isPassword = false, bool enabled = true, TextInputType inputType = TextInputType.text, Widget? suffixIcon, List<TextInputFormatter>? inputFormator, Function(String)? onChange, Widget? prefix}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0.0),
    child: TextField(
      enabled: enabled,
      keyboardType: inputType,
      controller: controller,
      obscureText: isPassword,
      inputFormatters: inputFormator,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        icon: prefix,
        prefixStyle: TextStyle(color: Colors.red),
        contentPadding: EdgeInsets.only(left: 24, right: 24),
        hintText: label,
        hintStyle: FontStyles.getStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF202020),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      onChanged: (onChange != null) ? onChange : (val) {},
    ),
  );
}

//build drop down

Widget buildDropdownField({
  required String label,
  required List<String> items,
  String? selectedValue,
  required ValueChanged<String?> onChanged,
  String? Function(String?)? validator, // Optionally for validation
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: DropdownButtonFormField<String>(
      value: selectedValue,
      hint: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF202020),
        ),
      ),
      decoration: InputDecoration(
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF202020),
        ),
        contentPadding: EdgeInsets.only(left: 24, right: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item.toUpperCase(),
          child: Text(
            item,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF202020),
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator, // Validation logic can be added here
    ),
  );
}

Widget loaderWidget() {
  return Positioned.fill(
    child: Container(
      color: Colors.black.withOpacity(0.2), // Semi-transparent overlay
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
    ),
  );
}

//check internet
Future<String> checkInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.mobile) {
    return 'Connected to a mobile network';
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return 'Connected to a Wi-Fi network';
  } else if (connectivityResult == ConnectivityResult.ethernet) {
    return 'Connected via Ethernet';
  } else {
    return 'No internet connection available';
  }
}

Color hexToColor(String hexColor) {
  // Remove the `#` if it exists
  hexColor = hexColor.replaceAll('#', '');
  // Add the alpha channel if it's not provided (default to 0xFF for full opacity)
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }
  // Convert to Color
  return Color(int.parse('0x$hexColor'));
}

void showToast(String message, {ToastGravity gravity = ToastGravity.BOTTOM, int duration = 3}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    // You can also use Toast.LENGTH_LONG
    gravity: gravity,
    // Position of the toast
    timeInSecForIosWeb: duration,
    // Duration of the toast message
    backgroundColor: Colors.black.withOpacity(0.7),
    // Background color
    textColor: Colors.white,
    // Text color
    fontSize: 14.0, // Font size of the message
  );
}

void showPersistentToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black.withOpacity(0.7),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: Colors.orange,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}

String mapToQueryString(Map<String, dynamic> params) {
  if (params.isEmpty) return '';
  print(params);

  final query = '?' + params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}').join('&');
  print(query);
  return query;
}

void showNoInternetAlert(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)?.noInternetConnection ?? 'No Internet Connection'),
        content: Text(AppLocalizations.of(context)?.pleaseCheckYourNetworkSettings ?? 'Please check your network settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)?.ok ?? 'OK'),
          ),
        ],
      );
    },
  );
}

String stripHtmlTags(String htmlString) {
  var document = parse(htmlString); // Parse the HTML string
  return document.body?.text ?? ''; // Extract and return plain text
}


bool isUserLoggedIn(){
  final token = SharedPreferencesHelper.getString('token');
  print(">>>>>>>>>>. $token");
  if (token != null && token != '') {
    return true;
  }else {
    return false;
  }
}



void showLoginAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(AppLocalizations.of(context)?.loginRequired ?? 'Login Required'),
        content: Text(AppLocalizations.of(context)?.pleaseLoginToAccessFeature ?? 'Please login to access feature of app.'),
        actions: [
          TextButton(
            onPressed: () {
              // Action when button is pressed
              Navigator.of(context).pop(); // Closes the dialog
              NavigationService.navigateTo('/loginPage',arguments: true);
            },
            child: Text(AppLocalizations.of(context)?.login ?? 'Login'),
          ),
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
          ),
        ],
      );
    },
  );
}


String convertToUrlParams(String baseUrl, Map<String, dynamic> params) {
  print(">>>>>>>>>>>>> $params");
  if (params.isEmpty) return baseUrl; // Return base URL if no params

  final queryString = Uri(queryParameters: params).query;
  return '$baseUrl?$queryString';
}