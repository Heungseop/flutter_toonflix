import 'package:flutter_toonflix/models/webrtoon_model.dart';

class WebToonDetailModel extends WebToonModel {
  final String about, genre, age;

  WebToonDetailModel.fromJson(String id, Map<String, dynamic> json)
      : about = json['about'],
        genre = json['genre'],
        age = json['age'],
        super.fromJson(id: id, json: json);
}
