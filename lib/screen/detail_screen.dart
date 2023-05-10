import 'package:flutter/material.dart';
import 'package:flutter_toonflix/models/webrtoon_detail_model.dart';
import 'package:flutter_toonflix/models/webrtoon_episode_model.dart';
import 'package:flutter_toonflix/widgets/episode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final String id, title, thumb;

  const DetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebToonDetailModel> webtoon;
  late Future<List<WebToonEpisodeModel>> epList;
  late SharedPreferences prefs;
  bool isLike = false;

  Future initPref() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList("likedToons");
    if (likedToons != null) {
      setState(() {
        isLike = likedToons.contains(widget.id);
      });
    } else {
      prefs.setStringList("likedToons", []);
    }
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
    var likedToons = prefs.getStringList("likedToons");

    if (likedToons != null) {
      var set = Set<String>.from(likedToons);
      likedToons = set.toList();
      setState(() {
        isLike ? likedToons!.remove(widget.id) : likedToons!.add(widget.id);
        isLike = !isLike;
      });
      // print("$isLike, $likedToons");
      await prefs.setStringList("likedToons", likedToons);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: isLike
                ? const Icon(Icons.favorite_outlined)
                : const Icon(Icons.favorite_outline_outlined),
          )
        ],
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      width: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 15,
                                offset: const Offset(10, 10),
                                color: Colors.black.withOpacity(.5))
                          ]),
                      child: Image.network(
                        widget.thumb,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }
                  return const Text("...");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: epList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var ep in snapshot.data!) EpisodeWidget(ep: ep),
                      ],
                    );
                  }
                  return const Text("...");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
