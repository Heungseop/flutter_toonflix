import 'dart:convert';

import 'package:flutter_toonflix/models/webrtoon_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  final String today = "today";

  Future<List<WebToonModel>> getTodayToons() async {
    print("getTodayToons");
    List<WebToonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final r = await http.get(url);

    if (r.statusCode == 200) {
      List<dynamic> toons = jsonDecode(r.body);

      for (var json in toons) {
        final toon = WebToonModel.fromJson(json);
        webtoonInstances.add(toon);
      }

      print("finish getTodayToons");
      return webtoonInstances;
    }

    throw Error();
  }
}
