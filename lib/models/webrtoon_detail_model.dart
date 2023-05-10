class WebToonDetailModel {
  final String title, about, genre, age, thumb;

  WebToonDetailModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        about = json['about'],
        genre = json['genre'],
        age = json['age'],
        thumb = json['thumb'];

  @override
  String toString() {
    return "title = $title";
  }
}
