part of 'services.dart';

class MasterDataService {
  static Future<List<Province>> getProvince() async {
    var response = await http.get(
      Uri.http(
        Const.baseUrl,
        '/starter/province',
      ),
      headers: <String, String>{
        'key': Const.apiKey,
        'content-type': 'application/json; charset=UTF-8',
      },
    );

    var job = json.decode(response.body);
    List<Province> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => Province.fromJson(e))
          .toList();
    }

    return result;
  }

  static Future<List<City>> getCity(var provId) async {
    var response = await http.get(
      Uri.http(
        Const.baseUrl,
        '/starter/city',
      ),
      headers: <String, String>{
        'key': Const.apiKey,
        'content-type': 'application/json; charset=UTF-8',
      },
    );

    var job = json.decode(response.body);
    List<City> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => City.fromJson(e))
          .toList();
    }

    List<City> selectedCities = [];
    for (var city in result) {
      if (city.provinceId == provId) {
        selectedCities.add(city);
      }
    }

    return selectedCities;
  }
}
