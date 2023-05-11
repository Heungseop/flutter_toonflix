class WebToonModel {
  final String id, title;
  final String? thumb;

  // WebToonModel(this.id, this.title, this.thumb);
  WebToonModel.fromJson({String? id, required Map<String, dynamic> json})
      : id = id ?? json['id'],
        title = json['title'],
        thumb = json['thumb'];

  @override
  String toString() {
    return "id = $id, title = $title, thumb = $thumb,";
  }
}
