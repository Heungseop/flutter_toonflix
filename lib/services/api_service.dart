import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  final String today = "today";

  void getTodayToons() async {
    final url = Uri.parse('$baseUrl/$today');
    final r = await http.get(url);

    if (r.statusCode == 200) {
      print(r.body);
      return;
    }

    throw Error();
  }
}
