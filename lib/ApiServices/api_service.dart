import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sanaa/SharedPrefrence/shared_prefrence.dart';

import '../Screens/Account/Model/language_model.dart';

class ApiService {
  final String baseUrl = 'https://sanna-api.udaipurhiring.com/api/v1/';
  //final String baseUrl = 'https://api-sanaa.arshantanu.in/api/v1/';
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      contentType: 'application/json',
    ));
  }

  Future<T> request<T>({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    // Check internet connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection available.');
    }

    final urlString = endpoint;
    print("urlstr: $baseUrl$urlString");

    Map<String, dynamic> updatedQueryParameters = queryParameters != null ? Map<String, String>.from(queryParameters) : {};
    updatedQueryParameters['currency'] = SharedPreferencesHelper.getString('savedCurrency') ?? 'KES';
   // updatedQueryParameters['locale'] = SharedPreferencesHelper.getString('locale') ?? 'en';
    final savedLanguage = SharedPreferencesHelper.getCustomObject<LanguageData>(
      'language',
          (json) => LanguageData.fromJson(json),
    );
    updatedQueryParameters['locale'] = savedLanguage?.locale ?? 'en';

    final uri = (updatedQueryParameters.isNotEmpty)
        ? () {
            final originalUri = Uri.parse(baseUrl + urlString);
            // Extract existing query parameters
            final existingQueryParameters = originalUri.queryParameters;
            // Merge existing and updated query parameters
            final mergedQueryParameters = {
              ...existingQueryParameters, // Keep existing parameters
              ...updatedQueryParameters, // Add or override with new parameters
            };
            // Create new Uri with merged query parameters
            return originalUri.replace(queryParameters: mergedQueryParameters).toString();
          }()
        : urlString;

    print("url: $uri");

    final bearerToken = await SharedPreferencesHelper.getString('token');
    print("bearerToken:: $bearerToken");

    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (bearerToken != null && bearerToken.isNotEmpty) 'Authorization': 'Bearer $bearerToken',
    };

    // Add currency to body for POST and PATCH requests
    Map<String, dynamic>? updatedBody = body;
    if (method.toUpperCase() == 'POST' || method.toUpperCase() == 'PATCH') {
      updatedBody = body != null ? Map<String, dynamic>.from(body) : {};
      updatedBody['currency'] = SharedPreferencesHelper.getString('savedCurrency') ?? 'KES';
    }

    print("Request URL:$uri");
    print("Request Body: ${jsonEncode(updatedBody)}");

    try {
      final options = Options(
        method: method.toUpperCase(),
        headers: defaultHeaders,
      );

      Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          response = await _dio.post(
            uri,
            data: updatedBody, // Use updatedBody
            options: options,
            queryParameters: updatedQueryParameters,
          );
          break;
        case 'PATCH':
          response = await _dio.patch(
            uri,
            data: updatedBody, // Use updatedBody
            options: options,
            queryParameters: updatedQueryParameters,
          );
          break;
        case 'DELETE':
          response = await _dio.delete(
            uri,
            data: updatedBody, // Use updatedBody
            options: options,
            queryParameters: updatedQueryParameters,
          );
          break;
        case 'GET':
        default:
          response = await _dio.get(
            uri,
            options: options,
            queryParameters: updatedQueryParameters,
          );
          break;
      }

      // Rest of the code remains unchanged
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.data}");

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        print("Response Status: ${response.statusCode}");
        return fromJson(response.data);
      } else if (response.statusCode == 409) {
        print("Response Status: ${response.statusCode}");
        throw Exception('status: ${response.statusCode},${response.data['message'] ?? response.statusMessage}}');
      } else if (response.statusCode != null && response.statusCode! >= 400 && response.statusCode! < 500) {
        print("Response Status: ${response.statusCode}");
        throw Exception('${response.data['message'] ?? response.statusMessage}');
      } else if (response.statusCode != null && response.statusCode! >= 500) {
        print("Response Status: ${response.statusCode}");
        throw Exception('${response.statusMessage}');
      } else {
        print("Response Status: ${response.statusCode}");
        throw Exception('${response.data}');
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
      if (e.response?.statusCode == 409) {
        print("Response Status: ${e.response?.statusCode}");
       // throw Exception('status: ${e.response?.statusCode},${e.response?.data['message'] ?? e.message}, ${e.response}');
        return fromJson(e.response?.data);
      }else  if (e.response != null) {
          print("Dio Error Response: ${e.response?.statusCode}");
          throw Exception('${e.response?.data['message'] ?? e.message}');
        } else {
          print("Dio Error: ${e.message}");
          throw Exception(e.message);
        }
      }
      rethrow;
    }
  }
/*Future<T> request<T>({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  })
  async {
    // Check internet connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection available.');
    }

    final urlString = endpoint; // Since baseUrl is already set in Dio
    print("urlstr: $baseUrl$urlString");
    final uri = (queryParameters != null)
        ? Uri.parse(baseUrl + urlString).replace(queryParameters: queryParameters).toString()
        : urlString;
    print("url: $uri");

    final bearerToken = await SharedPreferencesHelper.getString('token');
    print("bearerToken:: $bearerToken");

    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
    };

    print("Request URL: $baseUrl$uri");
    print("Request Body: ${jsonEncode(body)}");

    try {
      // Set up options with headers
      final options = Options(
        method: method.toUpperCase(),
        headers: defaultHeaders,
      );

      Response response;

      // Determine HTTP method
      switch (method.toUpperCase()) {
        case 'POST':
          response = await _dio.post(
            uri,
            data: body,
            options: options,
            queryParameters: queryParameters,
          );
          break;
        case 'PATCH':
          response = await _dio.patch(
            uri,
            data: body,
            options: options,
            queryParameters: queryParameters,
          );
          break;
        case 'DELETE':
          response = await _dio.delete(
            uri,
            data: body,
            options: options,
            queryParameters: queryParameters,
          );
          break;
        case 'GET':
        default:
          response = await _dio.get(
            uri,
            options: options,
            queryParameters: queryParameters,
          );
          break;
      }

      // Log the response
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.data}");

      // Handle different status codes
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Success
        return fromJson(response.data);
      } else if (response.statusCode == 409) {
        // Conflict
        throw Exception('status: ${response.statusCode},${response.data['message'] ?? response.statusMessage}}');
      } else if (response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! < 500) {
        // Client error
        throw Exception('${response.data['message'] ?? response.statusMessage}');
      } else if (response.statusCode != null &&
          response.statusCode! >= 500) {
        // Server error
        throw Exception('${response.statusMessage}');
      } else {
        // Unknown error
        throw Exception('${response.data}');
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        // Handle Dio-specific errors
        if (e.response != null) {
          print("Dio Error Response: ${e.response?.data}");
          throw Exception('${e.response?.data['message'] ?? e.message}');
        } else {
          print("Dio Error: ${e.message}");
          throw Exception(e.message);
        }
      }
      rethrow;
    }
  }*/
}
