import 'package:news_retry_app/models/source_response.dart';
import 'package:news_retry_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetSourcesBloc {
  final NewRepository _repository = NewRepository();
  final BehaviorSubject<SourceResponse> _subject =
      BehaviorSubject<SourceResponse>();

  getSources() async {
    SourceResponse response = await _repository.getSources();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<SourceResponse> get subject => _subject;
}

final getSourcesBloc = GetSourcesBloc();
