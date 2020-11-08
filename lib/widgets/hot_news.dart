import 'package:flutter/material.dart';
import 'package:news_retry_app/bloc/get_hot_news_bloc.dart';
import 'package:news_retry_app/elements/error_element.dart';
import 'package:news_retry_app/elements/loader_element.dart';
import 'package:news_retry_app/models/article_model.dart';
import 'package:news_retry_app/models/article_response_model.dart';
import 'package:news_retry_app/style/theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class HotNewsWidget extends StatefulWidget {
  @override
  _HotNewsWidgetState createState() => _HotNewsWidgetState();
}

class _HotNewsWidgetState extends State<HotNewsWidget> {
  @override
  void initState() {
    super.initState();
    getHotNewsBloc.getHotNews();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: getHotNewsBloc.subject.stream,
      builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return buildErrorWidget(snapshot.data.error);
          }
          return buildHotNews(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.data.error);
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Container buildHotNews(ArticleResponse data) {
    Size size = MediaQuery.of(context).size;
    List<ArticleModel> articles = data.articles;
    if (articles.length == 0) {
      return Container(
        width: size.width,
        child: Column(
          children: [
            Text("No Hot news"),
          ],
        ),
      );
    } else {
      return Container(
        height: size.height * 0.9,
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(
            articles.length,
            (index) => buildHotNewsTile(articles[index]),
          ),
        ),
      );
    }
  }

  Container buildHotNewsTile(ArticleModel article) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[100],
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(1, 1),
              )
            ],
          ),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: article.urlToImage != null
                          ? AssetImage("assets/images/img_placeholder.png")
                          : NetworkImage(article.urlToImage),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 15.0,
                ),
                child: Text(
                  article.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(height: 1.3, fontSize: 15),
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    width: 180.0,
                    height: 1.0,
                    color: Colors.black12,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    width: 30.0,
                    height: 3.0,
                    color: AppTheme.mainColor,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article.source.name,
                          style: TextStyle(
                            color: AppTheme.mainColor,
                            fontSize: 10.0,
                          ),
                        ),
                        Text(
                          timeAgo(article.publishedAt),
                          style: TextStyle(
                            color: AppTheme.mainColor,
                            fontSize: 10.0,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String timeAgo(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
