import 'package:flutter/material.dart';
import 'package:flutter_toonflix/models/webrtoon_detail_model.dart';
import 'package:flutter_toonflix/models/webrtoon_episode_model.dart';
import 'package:flutter_toonflix/widgets/episode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import 'home_screen.dart';

class DetailScreen extends StatefulWidget {
  final String id, title;
  final String? thumb;
  final String heroIdPrefix;

  const DetailScreen({
    super.key,
    required this.id,
    required this.title,
    this.thumb,
    required this.heroIdPrefix,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final appBarExpendedHeight = 200.0;
  late Future<WebToonDetailModel> webtoon;
  late Future<List<WebToonEpisodeModel>> epList;
  late SharedPreferences prefs;
  bool isLike = false;

  Future initPref() async {
    setState(() {
      isLike = HomeScreen.likedIds.contains(widget.id);
    });

    prefs = await SharedPreferences.getInstance();
  }

  // 초기화하고 싶은 멤버가 있는데 생성자에서 못하는 경우 initState에서 작업한다.
  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    epList = ApiService.getLatestEpisodeById(widget.id);
    initPref();
  }

  onHeartTap() async {
    var likedToons = HomeScreen.likedIds;

    setState(() {
      isLike ? likedToons.remove(widget.id) : likedToons.add(widget.id);
      isLike = !isLike;
    });

    HomeScreen.likedIds = Set<String>.from(likedToons).toList();
    await prefs.setStringList("likedToons", likedToons);
    setState(() {
      HomeScreen.likeWebtoonsRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build webtoon : $webtoon");

    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: webtoon,
            builder: (context, webtoonSnapshot) {
              if (webtoonSnapshot.hasData) {
                final webtoonAfter = webtoonSnapshot.data;
                return FutureBuilder(
                  future: epList,
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CustomScrollView(
                        slivers: [
                          SliverLayoutBuilder(
                            builder: (context, constraints) {
                              final scrolled = constraints.scrollOffset >
                                  (appBarExpendedHeight / 2);
                              return SliverAppBar(
                                expandedHeight: appBarExpendedHeight,
                                pinned: true, // 스크롤 시 앱바를 밀고 리스트로 꽉채울지 아니면 고정할지
                                floating: false,
                                snap: false,
                                backgroundColor: Colors.green,
                                flexibleSpace: FlexibleSpaceBar(
                                  title: Text(
                                    widget.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      backgroundColor:
                                          scrolled ? null : Colors.black38,
                                    ),
                                  ),
                                  centerTitle: true,
                                  background: Image.network(
                                    widget.thumb!,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              );
                            },
                          ),
                          SliverFixedExtentList(
                            itemExtent: 250.0,
                            delegate: SliverChildBuilderDelegate(
                              childCount: 1,
                              (BuildContext context, int index) {
                                return ListTile(
                                  title: Column(
                                    children: [
                                      Text(
                                        webtoonAfter!.about,
                                        // style: const TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${webtoonAfter.genre} / ${webtoonAfter.age}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SliverFixedExtentList(
                            itemExtent: 55.0,
                            // 화면에 표시될 위젯을 설정
                            delegate: SliverChildBuilderDelegate(
                              childCount: snapshot.data!.length,
                              (BuildContext context, int index) {
                                return ListTile(
                                  title:
                                      EpisodeWidget(ep: snapshot.data![index]),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }

                    return const Text("...");
                  },
                );
              }
              return const Text("...");
            }));
  }
}
