import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_retry_app/bloc/get_top_headlines_bloc.dart';
import 'package:news_retry_app/elements/error_element.dart';
import 'package:news_retry_app/elements/loader_element.dart';
import 'package:news_retry_app/models/article_model.dart';
import 'package:news_retry_app/models/article_response_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class HeadlineSliderWidget extends StatefulWidget {
  @override
  _HeadlineSliderWidgetState createState() => _HeadlineSliderWidgetState();
}

class _HeadlineSliderWidgetState extends State<HeadlineSliderWidget> {
  @override
  void initState() {
    super.initState();
    getTopHeadlineBloc.getHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
        stream: getTopHeadlineBloc.subject.stream,
        builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return buildErrorWidget(snapshot.data.error);
            }
            return _buildHeadlineSlider(snapshot.data);
          } else if (snapshot.hasError) {
            return buildErrorWidget(snapshot.data.error);
          } else {
            return buildLoadingWidget();
          }
        });
  }

  Widget _buildHeadlineSlider(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          viewportFraction: 0.9,
          enlargeCenterPage: false,
        ),
        items: articles
            .map(
              (e) => buildExpenseImage(e),
            )
            .toList(),
      ),
    );
  }

  GestureDetector buildExpenseImage(ArticleModel e) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: e.urlToImage != null
                      ? NetworkImage(e.urlToImage)
                      : AssetImage("assets/images/img_placeholder.png"),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.1, 0.9],
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.white.withOpacity(0.0)
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: 250,
                child: Column(
                  children: [
                    Text(
                      e.title,
                      style: TextStyle(
                        color: Colors.white,
                        height: 1.5,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                e.source.name,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 9.0,
                ),
              ),
            ),
            Positioned(
              child: Text(
                timeAgo(e.publishedAt),
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 9,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String timeAgo(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
