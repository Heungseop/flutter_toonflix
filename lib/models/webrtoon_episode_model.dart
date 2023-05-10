class WebToonEpisodeModel {
  final String webtoonId, id, title, thumb, rating, date;

  WebToonEpisodeModel.fromJson(this.webtoonId, Map<String, dynamic> json)
      : title = json['title'],
        id = json['id'],
        rating = json['rating'],
        date = json['date'],
        thumb = json['thumb'];

  @override
  String toString() {
    return "title = $title";
  }
}
  // var temp = {
  //   "id": "796152",
  //   "title": "마루는 강쥐",
  //   "thumb":
  //       "https://image-comic.pstatic.net/webtoon/796152/thumbnail/thumbnail_IMAG21_26b9c1d8-ca2d-4fc7-87ea-a3334634236a.jpg",
  // };
