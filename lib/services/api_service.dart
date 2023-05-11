import 'dart:convert';

import 'package:flutter_toonflix/models/webrtoon_detail_model.dart';
import 'package:flutter_toonflix/models/webrtoon_episode_model.dart';
import 'package:flutter_toonflix/models/webrtoon_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";
  static const String episodes = "episodes";

  static Future<List<WebToonModel>> getTodayToons() async {
    List<WebToonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final r = await http.get(url);

    if (r.statusCode == 200) {
      List<dynamic> toons = jsonDecode(r.body);

      for (var json in toons) {
        final toon = WebToonModel.fromJson(json: json);
        webtoonInstances.add(toon);
      }

      return webtoonInstances;
    }

    throw Error();
  }

  static Future<WebToonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final r = await http.get(url);

    if (r.statusCode == 200) {
      return WebToonDetailModel.fromJson(id, jsonDecode(r.body));
    }

    throw Error();
  }

  static Future<List<WebToonEpisodeModel>> getLatestEpisodeById(
      String id) async {
    List<WebToonEpisodeModel> episodeInstances = [];
    final url = Uri.parse('$baseUrl/$id/$episodes');
    final r = await http.get(url);

    if (r.statusCode == 200) {
      final epis = jsonDecode(r.body);

      for (var json in epis) {
        final ep = WebToonEpisodeModel.fromJson(id, json);
        episodeInstances.add(ep);
      }

      return episodeInstances;
    }
    throw Error();
  }
}
