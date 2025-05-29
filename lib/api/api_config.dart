import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String devApi = dotenv.env['API_BASE_URL']!;

class ApiConfig {
  static const String dev = "http://10.0.2.2:3000";
  static String prod = "https://backend-pet-sitting-family.vercel.app";

  static String get baseUrl => kDebugMode ? dev : prod;
  // static String get baseUrl =>  prod;
  static Map<String, String> get headerConfig => {
    "Content-type": "application/json",
    "Platform": "mobileApp"
  };
}