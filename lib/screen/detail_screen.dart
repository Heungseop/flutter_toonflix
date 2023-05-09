import 'package:flutter/material.dart';
import 'package:flutter_toonflix/models/webrtoon_detail_model.dart';
import 'package:flutter_toonflix/models/webrtoon_episode_model.dart';

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
  // = ApiService.getToonById(widget.id);

  // 초기화하고 싶은 멤버가 있는데 생성자에서 못하는 경우 initState에서 작업한다.
  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    epList = ApiService.getLatestEpisodeById(widget.id);
    print(webtoon);
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
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
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
        ],
      ),
    );
  }
}
