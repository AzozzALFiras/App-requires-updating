// Developer by : Azozz ALFiras

import 'dart:convert';
import 'package:http/http.dart' as http;

class AppStoreInfoApp {
  Future<Map<String, dynamic>> sentRequest(String bundleId) async {
    final response = await http.get(Uri.parse('http://itunes.apple.com/lookup?bundleId=$bundleId'));
    final data = json.decode(response.body);
    return data['results'][0];
  }

  Future<Map<String, dynamic>> getInfoApp(String bundleId, String version) async {
    final data = await sentRequest(bundleId);
    final vAppStore = data['version'];
    final appLink = data['trackViewUrl'];

    if (vAppStore == version) {
      return responseApi('Yes', appLink);
    } else {
      return responseApi('No', appLink);
    }
  }

  Map<String, dynamic> responseApi(String status, String url) {
    if (status == 'Yes') {
      return {
        'status': 'success',
        'status_message': 'There is no application update',
      };
    } else {
      return {
        'status': 'failed',
        'status_message': 'The version does not match. An update is required',
        'app_link': url,
      };
    }
  }
}
