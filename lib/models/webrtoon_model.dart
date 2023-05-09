class WebToonModel {
  final String id, title, thumb;

  WebToonModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        thumb = json['thumb'];

  @override
  String toString() {
    return "id = $id, title = $title, thumb = $thumb,";
  }
}
  // var temp = {
  //   "id": "796152",
  //   "title": "마루는 강쥐",
  //   "thumb":
  //       "https://image-comic.pstatic.net/webtoon/796152/thumbnail/thumbnail_IMAG21_26b9c1d8-ca2d-4fc7-87ea-a3334634236a.jpg",
  // };
