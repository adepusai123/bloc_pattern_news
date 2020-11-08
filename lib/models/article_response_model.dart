// To parse this JSON data, do
//
//     final articleResponse = articleResponseFromJson(jsonString);

import 'dart:convert';

import 'package:news_retry_app/models/article_model.dart';

ArticleResponse articleResponseFromJson(String str) =>
    ArticleResponse.fromJson(json.decode(str));

String articleResponseToJson(ArticleResponse data) =>
    json.encode(data.toJson());

class ArticleResponse {
  ArticleResponse({
    this.status,
    this.totalResults,
    this.articles,
    this.error,
  });

  String error;
  String status;
  int totalResults;
  List<ArticleModel> articles;

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      ArticleResponse(
        error: '',
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<ArticleModel>.from(
            json["articles"].map((x) => ArticleModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": "",
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };

  factory ArticleResponse.withError(String errorValue) => ArticleResponse(
        error: errorValue,
        status: '400',
        totalResults: 0,
        articles: List(),
      );
}
