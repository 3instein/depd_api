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

  static Future<List<Costs>> getMyOngkir(
      dynamic ori, dynamic dest, int weight, dynamic courier) async {
    var response = await http.post(
        Uri.http(
          Const.baseUrl,
          '/starter/cost',
        ),
        headers: <String, String>{
          'key': Const.apiKey,
          'content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'origin': ori,
          'destination': dest,
          'weight': weight,
          'courier': courier,
        }));
    var job = json.decode(response.body);

    List<Costs> costs = [];

    if (response.statusCode == 200) {
      costs = (job['rajaongkir']['results'][0]['costs'] as List)
          .map(
            (e) => Costs.fromJson(e),
          )
          .toList();
    }

    return costs;
  }
}
