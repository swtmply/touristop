import 'dart:convert';

import 'package:http/http.dart' as http;

class CovidSummary {
  final int total;
  final int recoveries;
  final int deaths;
  final int activeCases;

  const CovidSummary(
      {required this.total,
      required this.recoveries,
      required this.deaths,
      required this.activeCases});

  static fromJson(Map<String, dynamic> json) {
    return CovidSummary(
      total: json['data']['total'],
      recoveries: json['data']['recoveries'],
      deaths: json['data']['deaths'],
      activeCases: json['data']['active_cases'],
    );
  }

  static Future<CovidSummary> fetchCovidSummary() async {
    final response = await http.get(
      Uri.parse(
          'https://covid19-api-philippines.herokuapp.com/api/summary?city_mun=city+of+manila'),
    );

    if (response.statusCode == 200) {
      return CovidSummary.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load summary');
    }
  }
}
