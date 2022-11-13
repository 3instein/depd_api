part of 'services.dart';

class RajaOngkirService {
  static Future<http.Response> getOngkir() {
    return http.post(
        Uri.http(
          Const.baseUrl,
          '/starter/cost',
        ),
        headers: <String, String>{
          'key': Const.apiKey,
          'content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'origin': '501',
          'destination': '114',
          'weight': 1700,
          'courier': 'jne',
        }));
  }
}
