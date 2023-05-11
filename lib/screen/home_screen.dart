import 'package:flutter/material.dart';
import 'package:flutter_toonflix/models/webrtoon_detail_model.dart';
import 'package:flutter_toonflix/models/webrtoon_model.dart';
import 'package:flutter_toonflix/services/api_service.dart';
import 'package:flutter_toonflix/widgets/webtoon_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static late _HomeScreenState st;
  static Future<List<WebToonModel>> alltoons = ApiService.getTodayToons();
  static List<WebToonDetailModel> likeWebtoons = [];
  static late List<String> likedIds;

  const HomeScreen({super.key});

  static void likeWebtoonsRefresh() async {
    // likeWebtoons = await alltoons.then((value) => value.where((e) => HomeScreen.likedIds.contains(e.id)).toList());
    likeWebtoons = [
      for (String id in HomeScreen.likedIds) await ApiService.getToonById(id)
    ];
    st.setState(() {});
  }

  @override
  // ignore: no_logic_in_create_state
  State<HomeScreen> createState() {
    st = _HomeScreenState();
    return st;
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final now = DateTime.now();

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initPref();
  }

  Future initPref() async {
    prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList("likedToons");

    if (list == null) {
      prefs.setStringList("likedToons", []);
      HomeScreen.likedIds = [];
    } else {
      HomeScreen.likedIds = list;
    }
    setState(() {
      HomeScreen.likeWebtoonsRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    var ee = DateFormat.EEEE("ko_KR").format(now).substring(0, 2);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "$ee 웹툰",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: HomeScreen.alltoons,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(child: makeList(snapshot.data!, "all"))
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          const Text(
            "I Like 🧡",
            style: TextStyle(
                fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: makeList(HomeScreen.likeWebtoons, "like"),
          ),
        ],
      ),
    );
  }

  ListView makeList(List<WebToonModel> list, String heroIdPrefix) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        var webtoon = list[index];
        return Webtoon(
          id: webtoon.id,
          title: webtoon.title,
          thumb: webtoon.thumb,
          heroIdPrefix: heroIdPrefix,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 20,
      ),
    );
  }
}
