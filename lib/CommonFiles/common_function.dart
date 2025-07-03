import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sanaa/CommonFiles/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../Navigation/navigation_service.dart';
import '../Screens/ProductDetailPage/model/product_review_model.dart';
import '../SharedPrefrence/shared_prefrence.dart';
import 'common_variables.dart';
import 'dart:convert';
import 'dart:math';

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




Widget buildReviewDialog({
  required BuildContext context,
  required TextEditingController reviewController,
  required double rating,
  required Function crossTapped,
  required Function(double) onRatingChanged,
  required Function(Map<String, dynamic>) onSubmit,
  required String productId,
  String title = "Write a Review",
  String hintText = "Describe your experience?",
  String rateText = "Rate",
  String submitText = "Submit Review",
  String emptyReviewMessage = "Review detail should not be empty",
  Color backgroundColor = Colors.black,
  Color dialogColor = Colors.white,
  Color starColor = const Color(0xFF318531),
  double dialogWidthFactor = 0.8,
  double dialogHeight = 420,
  double starSize = 40,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    color: backgroundColor.withOpacity(0.5),
    child: Center(
      child: Container(
        width: MediaQuery.of(context).size.width * dialogWidthFactor,
        height: dialogHeight,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: dialogColor,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => crossTapped()
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              rateText,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            StarRating(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              size: starSize,
              rating: rating,
              allowHalfRating: true,
              onRatingChanged: onRatingChanged,
              color: starColor,
              emptyIcon: Icons.star,
              halfFilledIcon: Icons.star_half_outlined,
              filledIcon: Icons.star,
            ),
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    if (reviewController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(emptyReviewMessage)),
                      );
                      return;
                    }
                    final param = {
                      "product_id": productId,
                      "review": reviewController.text,
                      "rating": rating,
                    };
                    onSubmit(param);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: backgroundColor,
                  ),
                  child: Text(
                    submitText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildReviewTile(ProductReview review) {
  return Container(
    padding: EdgeInsets.all(15),
    margin: EdgeInsets.only(bottom: 22),
    decoration: BoxDecoration(
        border: Border.all(
          color: Color(
            0xFFC1DAC1,
          ),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                review.customerProfilePictureUrl ?? dummyImageUrl,
                height: 34,
                width: 34,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.customerName ?? 'guest',
                  style: FontStyles.getStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                StarRating(
                  size: 16,
                  rating: review.rating?.toDouble() ?? 0.0,
                  allowHalfRating: true,
                  onRatingChanged: (rating) {},
                  color: Color(0xFFFFCE00),
                  emptyIcon: Icons.star,
                  halfFilledIcon: Icons.star_half_outlined,
                  filledIcon: Icons.star,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          review.review ?? '',
          style: FontStyles.getStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    ),
  );
}


Future<void> clearAppCache() async {
  try {
    final appDir = await getApplicationDocumentsDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
      print('Application cache cleared');
    }
  } catch (e) {
    print('Error clearing app cache: $e');
  }
}


String generateNonce([int length = 32]) {
  const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

/// Returns the SHA256 hash of the input string
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<UserCredential> signInWithApple() async {
  try {
    // Generate a nonce to prevent replay attacks
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request Apple ID credential
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    print("Apple Credential: idToken=${appleCredential.identityToken}, authorizationCode=${appleCredential.authorizationCode}");
    // Create an OAuth credential for Firebase
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode
    );

    // Sign in to Firebase with the OAuth credential
    final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    // Return the user credential
    return userCredential;
  } catch (e) {
    // Handle errors (e.g., user canceled sign-in, network issues)
    print("Error during Apple Sign-In: $e");
    rethrow;
  }
}