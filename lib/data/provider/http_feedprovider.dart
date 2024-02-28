import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;

class sendMessageToEsp {
  static void fetchData(String message) async {
    final baseUrl = 'http://10.10.10.1/feed?ID=';

    // final url = Uri.parse(baseUrl);

    try {
      String finMessage = baseUrl + message.trim();
      print("this is finMessage=$finMessage");
      final response = await http.post(Uri.parse(finMessage));

      if (response.statusCode == 200) {
        print("message sent:$message");
      } else {
        // Request failed with an error
        print('API Request failed with status ${response.body}');
      }
    } catch (e) {
      // Handle exceptions, such as network errors or invalid URLs
      print('Error: $e');
    }
  }

  static void sendImage(String message) async {
    final baseUrl = 'http://10.10.10.1/feed?ID=';

    // final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(Uri.parse(baseUrl), body: message);

      if (response.statusCode == 200) {
        print("message sent:$message");
      } else {
        // Request failed with an error
        print('API Request failed with status ${response.body}');
      }
    } catch (e) {
      // Handle exceptions, such as network errors or invalid URLs
      print('Error: $e');
    }
  }
}
