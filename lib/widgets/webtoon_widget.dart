import 'package:flutter/material.dart';
import 'package:flutter_toonflix/screen/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String id, title;
  final String? thumb;
  final String heroIdPrefix;

  const Webtoon(
      {super.key,
      required this.id,
      required this.title,
      this.thumb,
      required this.heroIdPrefix});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              // fullscreenDialog: true,
              builder: (context) => DetailScreen(
                id: id,
                title: title,
                thumb: thumb,
                heroIdPrefix: heroIdPrefix,
              ),
            ));
      },
      child: Column(
        children: [
          Hero(
            tag: "$heroIdPrefix$id",
            child: thumb?.isEmpty ?? true
                ? Container(
                    width: 150,
                    height: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                    ),
                    child: const Text("no Image"),
                  )
                : Container(
                    width: 150,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 20,
                              offset: const Offset(3, 5),
                              color: Colors.black.withOpacity(.1))
                        ]),
                    child: Image.network(
                      thumb!,
                    ),
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
