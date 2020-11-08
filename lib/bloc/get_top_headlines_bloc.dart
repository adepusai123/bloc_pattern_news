import 'package:news_retry_app/models/article_response_model.dart';
import 'package:news_retry_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetTopHeadlineBloc {
  final NewRepository _repository = NewRepository();
  final BehaviorSubject<ArticleResponse> _subject =
      BehaviorSubject<ArticleResponse>();

  getHeadlines() async {
    ArticleResponse response = await _repository.getTopHeadline();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ArticleResponse> get subject => _subject;
}

final getTopHeadlineBloc = GetTopHeadlineBloc();
