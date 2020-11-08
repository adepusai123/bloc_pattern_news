import 'package:dio/dio.dart';
import 'package:news_retry_app/models/article_response_model.dart';
import 'package:news_retry_app/models/source_response.dart';

class NewRepository {
  static String mainUrl = "http://newsapi.org/v2";
  final String apiKey = "96f62a28927f44e69bea383b027ba5ca";

  String getTopHeadlineUrl = "$mainUrl/top-headlines";
  String getSourceUrl = "$mainUrl/sources";
  String everythingUrl = "$mainUrl/everything";

  final Dio _dio = Dio();

  Future<ArticleResponse> getTopHeadline() async {
    var params = {"apiKey": apiKey, "country": "us"};
    try {
      Response response =
          await _dio.get(getTopHeadlineUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print(
          "getTopHeadlines Repository Error occured: $error, stackTrace: $stackTrace");
      return ArticleResponse.withError(error);
    }
  }

  Future<SourceResponse> getSources() async {
    var params = {"apiKey": apiKey};
    try {
      Response response = await _dio.get(getSourceUrl, queryParameters: params);
      return SourceResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print(
          "getSources Repository Error occured: $error, stackTrace: $stackTrace");
      return SourceResponse.withError(error);
    }
  }
}
